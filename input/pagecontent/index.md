### Introduction

The Continuous Glucose Monitoring Implementation Guide provides a standardized approach for sharing Continuous Glucose Monitoring (CGM) data between actors. This Implementation Guide (IG) focuses on enabling the exchange of CGM data, including high-level reports and raw glucose observations, to support collaborative glucose management. The requirements for this guide were initially developed in the [Argonaut Project](https://confluence.hl7.org/spaces/AP/pages/86969961/Argonaut+Project+Home) with the input from patients, providers, CGM device vendors, app developers, and EHR systems and later in collaboration with the HL7 Orders and Observation Work Group.

### User Stories

#### Patient Connects a CGM App to a Provider's Electronic Health Record (EHR)

Sarah, a type 1 diabetes patient, is switching to a new doctor. She has been using a CGM device and a patient app that stores her CGM data on her phone or in an app backend server. The app supports secure health data exchange standards compatible with the CGM IG. Sarah authorizes the app to connect with her new provider's EHR, using her patient portal credentials to grant access to the phone app. The app then sends Sarah's CGM reports from the past 3 months to the new provider's EHR using FHIR, ensuring her new doctor can access her recent CGM history for informed decision-making.

#### Provider Connects to a Patient's CGM Data During a Patient Encounter
Dr. Johnson treats Michael, a type 2 diabetes patient struggling with glucose management. Dr. Johnson's practice uses "CloudCGM", a (fictional) cloud-based diabetes management platform that supports the CGM IG. Michael has a patient account in the CloudCGM platform, and a "Sharing Code" appears in his account settings. During a clinic visit, Dr. Johnson launches the CloudCGM SMART on FHIR app inside of the EHR, entering the sharing code that Michael reads aloud. This process establishes a linkage between Michael's records in the two systems. CloudCGM is now able to submit data every week into Dr. Johnson's EHR, with results appearing in the native interface and easily incorporated into visit notes.

#### Patient Shares CGM Data with a Research Study

Dr. Patel is the principal investigator for a longitudinal research study. Participants are recruited from multiple diabetes management platforms that support the CGM IG. The study protocol allows participants to share CGM data after completing an informed consent process. For consented participants, the diabetes management platforms submit a weekly data feed to a study server under Dr. Patel's control. The standardized format and exchange protocols enable an efficient, multi-platform study focused on collecting raw glucose readings as part of the data package.

### Actors

#### CGM Data Submitter

The data submitter is a software system that manages CGM data. It typically incorporates a patient-facing app and sometimes a clinician-facing EHR-integrated app and cloud service.

This IG also refers to Data Submitters as "**apps**" or "**diabetes management platforms**".

#### CGM Data Receiver

The data receiver is a software system that receives and stores the CGM data submitted by the data submitter.

This IG also refers to Data Receivers as "**EHRs**".

### Must Support

The Must Support (MS) flag requires that data submitters must be capable of sending the element, and data receivers must be able to parse it without error. While receivers must process the element, they may choose to ignore the data if it is not applicable to their system's use case, and must not reject a resource solely for containing it. For supported profiles, MS elements indicate which resource types and elements a submitter needs to be capable of submitting. MS on the CGM Data Submission Bundle indicates which types of resources a submitter needs to be capable of submitting.

This is an initial draft of MS to guide early implementations. The spec recognizes that actor-based MS may be needed in a future release.

While we have not labeled molar or mass units as MS, any conformant implementation must support at least one of these options.

### Nominal Workflow

<div style="max-width: 400px; float: none;">
{% include flow.svg %}
</div>

1. **App Authorization**: The Data Submitter completes an authorization process (e.g., [SMART App Launch](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#app-launch-launch-and-authorization) or [SMART Backend Services Authorization](https://www.hl7.org/fhir/smart-app-launch/backend-services.html)) to securely access the EHR system.

2. **Establish EHR Patient ID**: After successful authorization, the Data Submitter determines the "logical id" of the patient's `Patient` resource within the EHR's FHIR Server. The logical id can be discovered through authorization context (e.g., SMART's `launch/patient` context), through FHIR patient search, or using an out-of-band (OOB) process.

3. **Learn Submission Preferences**: The Data Submitter determines the EHR's CGM data submission preferences by:
   
   a. Querying the EHR FHIR server for a specific `ServiceRequest` resource that contains the CGM data submission standing order or
   
   b. Learning the submission schedule through an out-of-band process.

4. **Submission Triggers**: The Data Submitter determines when to submit data by:
   
   a. Scheduled Submission Interval: Based on the standing order obtained from the submission preferences, the Submitter initiates scheduled submissions of CGM data at the specified intervals.

   b. One-Time Orders: The Submitter may also support manual triggers, such as an in-app button, allowing users to initiate on-demand submissions of CGM data.

5. **Prepare FHIR Bundle**: When a submission is triggered (either scheduled or manual), the Data Submitter prepares a FHIR Bundle containing the relevant CGM data, conforming to the specified profiles and requirements.

6. **POST Bundle to EHR**: The Data Submitter issues a POST request to send the prepared FHIR Bundle to the EHR.

This workflow ensures that the Data Submitter is authorized, respects the EHR's submission preferences, and securely transmits CGM data in a standardized format. The combination of scheduled submissions and manual triggers provides flexibility and ensures that the EHR receives up-to-date CGM data as needed.


### Establishing Connections

#### Patient App to EHR

In this workflow, a patient-facing app connects directly to the EHR using the authorization capabilities of the EHR (e.g., SMART on FHIR). The app acts as a client and goes through an authorization process where the patient approves the app to access their EHR, granting write scopes. This process ensures that both the patient and the source EHR system agree to allow the app to write data using an appropriate access token.

**Technical Details**

{% assign launch_patient = "patient app will already know who the patient is, and only requires a corresponding ID from the EHR" %}
{% assign offline_access = "establish persistent access for long-term submissions" %}

* If SMART on FHIR is being used, relevant scopes include:
  * `launch/patient`: {{ launch_patient }}
  * `offline_access`: {{ offline_access }}
  * Data Scopes:
    * `patient/Patient.r`: it may still be desirable to cross-reference patient demographics, e.g. to confirm a match
    * `patient/ServiceRequest.rs?code=cgm-data-submission-standing-order`: helps the app learn the EHR's data submission preferences
    * `patient/DiagnosticReport.cu?category=LAB`: submit a summary report
    * `patient/Observation.cu?category=laboratory`: submit a summary observation or sensor reading
    * `patient/Device.cu`: submit device details associated with a sensor reading

#### Provider App to EHR

For provider-facing apps, the app can be integrated directly into the EHR's user interface using the SMART on FHIR EHR launch workflow. EHRs widely support this workflow, allowing apps to run within the EHR's screen real estate. The EHR-integrated app might represent a device manufacturer or an independent diabetes management platform. The app can retrieve the patient's ID and demographics from the EHR in real-time using the FHIR Patient API.

In-band or out-of-band processes can correlate the patient with a data record in the app's backend system.

Examples include but are not limited to:

1. A patient-facing companion app connects to the EHR using SMART on FHIR as described in "Patient App to EHR" above, establishing a record linkage via API.
2. A patient-facing companion app sends a push notification to the patient, asking if they want to establish a record linkage.
3. A patient-facing companion app generates a sign-up code that the provider enters into the EHR.
4. The provider has an appropriate data-sharing agreement with the app, allowing the app to match its patient list against EHR-sourced demographics.

**Technical Details**

* SMART on FHIR scopes that enable this scenario include:
  * `launch/patient` at linkage time
  * If using *patient*-level authorization at submission time
    * "Data Scopes" listed above
    * `offline_access`
  * If using *user*-level authorization at submission time
    * "Data Scopes" listed above, with the level of `user/`
    * `offline_access`
  * If using *system*-level authorization at submission time
    * "Data Scopes" listed above, with the level of `system/`
    * No need for `offline_access` because short-lived access tokens are available at any time via client credentials grant

### CGM Data Submission: Bundles

**☛ See [Example Bundle](Bundle-cgmDataSubmissionBundle.json.html#root)**

**☛ See [Full Data Profile](StructureDefinition-cgm-data-submission-bundle.html#profile)**

**☛ See [`$submit-cgm-bundle` Operation Definition](OperationDefinition-submit-cgm-bundle.html)**

{{ site.data.resources["StructureDefinition/cgm-data-submission-bundle"].description }}

> **Note:** Unlike standard FHIR transactions where servers must process all entries as a single unit, the `$submit-cgm-bundle` operation allows servers to selectively accept and persist only a subset of the submitted resources.

**Technical Details**

* CGM Data Submitters SHALL:
  1. POST a CGM Data Submission Bundle to `[base]/$submit-cgm-bundle`

* CGM Data Receivers:
  * SHALL advertise support for CGM Data Submission by including `http://hl7.org/fhir/uv/cgm/CapabilityStatement/cgm-data-receiver` in their `CapabilityStatement.instantiates`
  * SHALL Support the `$submit-cgm-bundle` operation at the server level
  * SHALL Include a status code for each entry in the response Bundle, indicating whether the entry was accepted 
  * MAY choose to store only a subset of resources in a submitted bundle
  * SHOULD ensure that accepted submissions are available for read/search immediately after submission, but MAY subject these submissions to additional ingestion workflow steps
  * MAY respond with an HTTP status code `429` (Too Many Requests) if a client is submitting data too frequently
  * SHALL document their support for conditional create operations in their developer documentation, including:
    * Whether conditional create requests are supported
    * Which search parameters can be used in conditional create requests
    * How client-supplied identifiers are handled
    * Any deduplication strategies employed
  * SHOULD implement strict validation and allow-listing rules for incoming `$submit-cgm-bundle` transaction Bundles. This includes, but is not limited to:
    * Permitting only `POST` operations for resources.
    * Allowing only CGM-relevant resource types (e.g., `Observation`, `Device`, `Patient`, `DiagnosticReport`, `ServiceRequest`).
    * Ensuring that all submitted resources pertain to the patient context established during authorization.
    * Rejecting bundles that contain disallowed operations or resource types.

    **Warning:** Accepting and processing arbitrary transaction Bundles without appropriate validation presents a security risk. Implementers must carefully consider the operations and resource types they will accept.
    {:.bg-warning}

**Handling Duplicate Submissions**

When submitting CGM data, there are two complementary approaches for handling potential duplicates:

1. **Client-Controlled Deduplication With Conditional Create**
   * Clients MAY include `ifNoneExist` elements in `Bundle.entry.request`
   * Clients MAY adopt any strategy for generating Identifiers, including strategies to deterministically create identifiers based on the instance data
   * Example of `Bundle.entry.request.ifNoneExist`: `identifier=https://client.example.org|123`
   * Servers SHOULD support conditional create requests
   * Servers SHOULD persist client-supplied identifiers to support this pattern
   * When a server supports conditional creates, it:
     * SHALL document which search parameters can be used
     * SHALL document how client-supplied identifiers are handled
     * SHALL respond according to the [FHIR Conditional Create](https://hl7.org/fhir/http.html#ccreate) specification:
       * 201 (Created) if the resource was created
       * 200 (OK) if there was one match that prevented creation, with location header populated
       * 412 (Precondition Failed) if multiple matches were found
   * When a server does not support conditional creates, it:
     * SHOULD NOT create resources for `Bundle.entry` elements that have the `ifNoneExist` element and, for each of these entries, respond with a status `400` in the response Bundle.
     * SHOULD create resources for other `Bundle.entry` elements according to other applicable rules.

2. **Server-Side Deduplication**
   * Servers MAY implement additional deduplication logic
   * When duplicates are detected, servers SHOULD either:
      * Return a 200 OK status indicating the submission was processed but not stored
      * Return a 201 Created status with a location header pointing to the existing resource
   * Servers SHALL document their deduplication strategy in their developer documentation

### CGM Data Submission: Standing Orders

**☛ See [Example Order ("Send a summary every two weeks")](ServiceRequest-cgmDataSubmissionStandingOrderExample.json.html#root)**

**☛ See [Full Data Profile](StructureDefinition-cgm-data-submission-standing-order.html#profile)**

{{ site.data.resources["StructureDefinition/cgm-data-submission-standing-order"].description }}

**Technical Details**

* CGM Submitters SHOULD respect the Receivers' submission preferences
* CGM Receivers MAY reject:
  * An entire submission Bundle (e.g., if the frequency of submissions is too high)
  * Any subset of a submission Bundle (as documented above)

### CGM Data Submission: One-Time Orders

**☛ See [Example Order ("Request data for all of 2024")](ServiceRequest-cgmDataSubmissionOneTimeOrderExample.json.html#root)**

**☛ See [Example Order ("Request data for last 30 days")](ServiceRequest-cgmDataSubmissionOneTimeOrder30DayExample.json.html#root)**

**☛ See [Full Data Profile](StructureDefinition-cgm-data-submission-one-time-order.html#profile)**

{{ site.data.resources["StructureDefinition/cgm-data-submission-one-time-order"].description }}

**Technical Details**

- CGM Data Receivers and Submitters SHOULD document their supported out-of-band mechanisms in their developer documentation

**Transmission Mechanism**

The mechanism for transmitting one-time orders from EHR to CGM Data Submitter is left out-of-band in this version of the specification. Implementation approaches may include direct API calls triggered by automated logic or explicit user actions.

Future versions of this specification may provide an in-band option based on implementation experience and community feedback.

**Technical Details**

* CGM Data Receivers and Submitters SHOULD document their supported out-of-band mechanisms in their developer documentation

### SMART Health Links for CGM Data Sharing

The Data Submission protocol defined above enables standardized integration between CGM data sources and receiving systems like EHRs. However, there are situations where tight integration is not feasible or desired. [SMART Health Links](https://docs.smarthealthit.org/smart-health-links/) (SHLinks) provide a complementary method for sharing CGM data and reports among patients, caregivers, clinicians, and other authorized parties. SHLinks allow users to easily share selected subsets of CGM data as needed, offering an always up-to-date data feed without the need for direct system integration between the sharing parties. Specific scenarios where SHLinks provide value include:

* Sharing with parties that cannot or do not integrate with the Data Submission protocol, such as schools, camps, temporary caregivers during travel, etc.
* Allowing patients granular control over what specific data is shared and with whom, beyond just provider-patient contexts.
* Providing a simple, accessible sharing method for non-technical users like patients and caregivers.
* Enabling temporary data sharing for finite needs like referrals, research studies, or consultations.

This IG ensures comprehensive interoperability that accommodates diverse real-world requirements across the CGM data-sharing landscape by defining a tightly orchestrated Data Submission API and a more loosely coupled SHLinks capability.

#### Actors

**SHLink Creator:** A system that can generate SHLinks containing CGM data and reports, acting as a SHLink Sharing Application.

**SHLink Receiver:** A system that can receive and process SHLinks containing CGM data and reports, acting as a SHLink Receiving Application.  

#### Workflow

1. The SHLink Creator allows the user to select the desired CGM data and reports to share and the time period to include. Options include:
    * Data to include: CGM Summary, CGM Sensor Readings, CGM Devices
    * Time period: Past 2 weeks, 1 month, 3 months, etc.
    * Link expiration time, if any

2. The SHLink Creator generates a SHLink containing the user-selected content, encrypted with a unique key.

3. The user shares the SHLink with the intended recipient(s), who use a SHLink Receiver to periodically access the shared data and stay up-to-date over time.  

4. The shared data conforms to the CGM Data Submission profiles, promoting interoperability and accessibility across different systems and platforms.

### Relationship with the PHD Implementation Guide

This Implementation Guide is designed to be complementary to the [Personal Health Device Implementation Guide (PHD)](https://hl7.org/fhir/uv/phd/2025Sep/). PHD provides a foundational framework for mapping device-level data into FHIR, focusing on information flows into and through a Personal Health Gateway. It intentionally specifies no interpretations of the data or assumptions about what data is important. It provides no interpretation of the mapped data or guidance on actions to be taken with the data once it has passed beyond the Gateway. In contrast, CGM focuses on a downstream clinical workflow: the submission of summary reports, key statistical metrics, and underlying measurements to a clinical system like an EHR.

A system can therefore use PHD as a guide for ingesting discrete sensor data. CGM provides guidance to share discrete results, generate summary observations, and produce clinical reports. For systems that originate data from a PHD-compliant gateway, it is possible to construct glucose Observations that conform to the profiles in both guides. The mapping between the PHD and CGM CodeSystem requirements is a point of further study.

### Note on Categories

This guide does not mandate specific `Observation.category` and `DiagnosticReport.category` values for CGM data. The appropriate categorization of CGM data will be addressed in future versions of this specification.

<!-- To Satisfy the QA warnings "An HTML fragment from the set [dependency-table.xhtml, dependency-table-short.xhtml, dependency-table-nontech.xhtml] is not included anywhere in the produced implementation guide", "The HTML fragment 'globals-table.xhtml' is not included anywhere in the produced implementation guide", and "The HTML fragment 'ip-statements.xhtml' is not included anywhere in the produced implementation guide" -->

### IG Dependencies

This guide is based on the FHIR R4 specification and relies on other implementation guides including:

{% include dependency-table-short.xhtml %} 

See the [Validation Page](qa.html) for the full list of dependencies.

### Global Profiles

{% include globals-table.xhtml %} 

### Copyrights

{% include ip-statements.xhtml %} 

<!-- ==================================== -->

### Package Downloads

{% include cross-version-analysis.xhtml %}

---

### Acknowledgments

This Implementation Guide was developed with the input and collaboration of numerous individuals and organizations. The project's initial collaboration space can be found on [Confluence: FHIR Write - CGM](https://confluence.hl7.org/spaces/AP/pages/234784555/FHIR+Write+-+CGM).

**Primary Editors:**

*   Josh Mandel (SMART Health IT, Microsoft)
*   Eric Haas (Health eData Inc)

**Key Contributors:**

*   Mikael Rinnetmäki (Sensotrend)
*   Brett Marquard (WaveOne Associates)
*   Marti Velezis

This guide benefited greatly from the foundational work and diverse perspectives brought forth during the Argonaut Project, including contributions from CGM device vendors, application developers, Electronic Health Record (EHR) system providers, patient advocates, and clinicians. Their collective insights were invaluable in shaping the requirements and solutions presented in this guide.
