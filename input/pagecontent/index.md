### Introduction

The Argo Continuous Glucose Monitoring Implementation Guide provides a standardized approach for sharing CGM data between actors. This IG focuses on enabling the exchange of CGM data, including high-level reports and raw glucose observations, to support collaborative glucose management.

### User Stories

#### Patient connects a CGM app to her EHR (from home)

Sarah, a type 1 diabetes patient, is switching to a new doctor. She has been using a CGM device and a patient app that stores her CGM data on her phone or in an app backend server. The app supports SMART on FHIR and is compatible with the Argo CGM IG. Sarah authorizes the app to connect with her new provider's EHR, using her patient portal credentials to grant access to the phone app. The app then sends Sarah's CGM reports from the past 3 months to the new provider's EHR using FHIR, ensuring her new doctor has access to her recent CGM history for informed decision-making.

#### Provider connects a patient's CGM (during a patient encounter)

Dr. Johnson treats Michael, a type 2 diabetes patient struggling with glucose management. Dr. Johnson's practice uses "CloudCGM", a (fictional) cloud-based diabetes management platform that supports the Argo CGM IG.  Michael has a patient account in the CloudCGM platform, and a "Sharing Code" appears in his account settings. During a clinic visit, Dr. Johnson launches the CloudCGM SMART on FHIR app inside of the EHR, entering the sharing code that Michael reads aloud. This process establishes a linkage between Michael's records in the two systems. CloudCGM is now able to submit data every week into Dr. Johnson's EHR, with results appearing in the native interface and easily incorporated into visit notes.

#### Patient shares CGM data with a research study

Dr. Patel is the principal investigator for a longitudinal research study. Participants are recruited from multiple diabetes management platforms that support the Argo CGM IG. The study protocol allows participants to share CGM data after completing an informed consent process. For consented participants, the diabetes management platforms submit a weekly data feed to a study server under Dr. Patel's control.  The standardized format and exchange protocols enable an efficient, multi-platform study focused on collecting raw glucose readings as part of the data package.

### Actors

#### CGM Data Submitter

The data submitter is a software system that manages CGM data. It typically incorporates a patient-facing app, and may also incorporate a clinician-facing EHR-integrated app and a cloud service.

This IG also refers to Data Submitters as "**apps**" or "**diabetes management platforms**".

#### CGM Data Receiver

The data receiver is a software system that receives and stores the CGM data submitted by the data submitter.

This IG also refers to Data Receivers as "**EHRs**".

{{ site.data.resources["CapabilityStatement/cgm-data-receiver"].description }}

### Nominal Workflow

<div style="max-width: 400px; float: none;">
{% include flow.svg %}
</div>

1. **App Authorization (SMART on FHIR)**: The Data Submitter completes a [SMART App Launch](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#app-launch-launch-and-authorization) or [SMART Backend Services Authorization](https://www.hl7.org/fhir/smart-app-launch/backend-services.html) to securely access the EHR system.

2. **Establish EHR Patient ID**: After successful authorization, the Data Submitter determines the patient's `id`  within the EHR's FHIR Server. This can be done through the SMART's `launch/patient` context, through FHIR patient search, or using an out-of-band (OOB) process.

3. **Learn Submission Preferences**: The Data Submitter determines the EHR's CGM data submission preferences by:
   a. Querying the EHR FHIR server for a specific `ServiceRequest` resource that contains the CGM data submission standing order, or
   b. Learning the submission schedule through an OOB process.

4. **Submission Triggers**: The Data Submitter determines when to submit data
   a. Scheduled Submission Interval: Based on the standing order obtained from the submission preferences, the Submitter initiates scheduled submissions of CGM data at the specified intervals.
   b. Manual Trigger: The Submitter may also support manual triggers, such as an in-app button, allowing users to initiate on-demand submissions of CGM data.

5. **Prepare FHIR Bundle**: When a submission is triggered (either scheduled or manual), the Data Submitter prepares a FHIR Bundle containing the relevant CGM data, conforming to the specified profiles and requirements.

6. **POST Bundle to EHR**: The Data Submitter issues a POST request to send the prepared FHIR Bundle to the EHR's FHIR Base URL.

This workflow ensures that the Data Submitter is properly authorized, respects the EHR's submission preferences, and securely transmits CGM data in a standardized format. The combination of scheduled submissions and manual triggers provides flexibility and ensures that the EHR receives up-to-date CGM data as needed.


### Establishing Connections

#### Patient App to EHR

In this workflow, a patient-facing app connects directly to the EHR using the SMART on FHIR capabilities of the EHR. The app acts as a SMART on FHIR client and goes through an OAuth process where the patient approves the app to access their EHR, granting write scopes. This ensures that both the patient and the source EHR system agree to allow the app to write data using an appropriate access token.

**Technical Details**

{% assign launch_patient = "patient app will already know who the patient is, and only requires a corresponding ID from the EHR" %}
{% assign offline_access = "establish persistent access for long-term submissions" %}

* SMART on FHIR scopes that enable this scenario include:
  * `launch/patient`: {{ launch_patient }}
  * `offline_access`: {{ offline_access }}
  * Data Scopes:
    * `patient/Patient.r`: it may still be desirable to cross-reference patient demographics, e.g. to confirm a match
    * `patient/ServiceRequest.rs?code=cgm-data-submission-standing-order`: helps app learn the EHR's data submission preferences
    * `patient/DiagnosticReport.cu?category=laboratory`: submit a summary report
    * `patient/Observation.cu?category=laboratory`: submit a summary observation or sensor reading
    * `patient/Device.cu`: submit device details associated with a sensor reading

#### Provider App to EHR

For provider-facing apps, the app can be integrated directly into the EHR's user interface using the SMART on FHIR EHR launch workflow. This workflow is widely supported by EHRs and allows apps to run within the EHR's screen real estate. The EHR-integrated app might represent a device manufacturer or an independent diabetes management platform. The app can retrieve the patient's ID and demographics from the EHR in real-time using the FHIR US Core Patient API.

To correlate the patient with a data record in the app's backend system, an in-brand or out-of-band process can be employed.

Examples include but are not limited to:

1. A patient-facing companion app connects to the EHR using SMART on FHIR as described in "Patient App to EHR" above, establishing a record linkage via API
2. A patient-facing companion app sends a push notification to the patient, asking if they want to establish a record linkage
3. A patient-facing companion app generates a sign-up code that the provider enters into the EHR.
4. The provider has an appropriate data sharing agreement in place with the app, allowing the app to match its patient list against  EHR-sourced demographics.

**Technical Details**

* SMART on FHIR scopes that enable this scenario include:
  * `launch/patient` at linkage time
  * If using *patient*-level authorization at submission time
    * "Data Scopes" listed above
    * `offline_access`
  * If using *user*-level authorization at submission time
    * "Data Scopes" listed above, with level of `user/`
    * `offline_access`
  * If using *system*-level authorization at submission time
    * "Data Scopes" listed above, with level of `system/`
    * No need for `offline_access` because short-lived access tokens are available at any time via client credentials grant

### CGM Data Submission: Bundles

**☛ See [Example Bundle](Bundle-cgmDataSubmissionBundle.json.html#root)**

**☛ See [Full Data Profile](StructureDefinition-cgm-data-submission-bundle.html#profile)**

{{ site.data.resources["StructureDefinition/cgm-data-submission-bundle"].description }}

**Technical Details**

* CGM Submitters and Receivers SHALL support bundle-based submission, and MAY support individual resource submission
* CGM Receivers MAY choose to store only a subset of resources in a submitted bundle
  * Each entry in the `batch-response` bundle SHALL provide a status code indicating whether the submission was accepted 
  * Accepted entries SHOULD be available for read/search immediately after submission, but MAY be subjected to additional ingestion workflow steps

CGM Data Receivers MAY respond with HTTP status code 429 (Too Many Requests) if a client is submitting data too frequently. When using this response, Receivers MAY include a `Retry-After` header specifying a time duration in seconds. For example: `Retry-After: 3600` suggests waiting one hour before the next submission attempt. This approach is complementary to, not a replacement for, pre-arranged submission schedules.

### CGM Data Submission: Standing Orders

**☛ See [Example Order ("Send a summary every two weeks")](ServiceRequest-cgmDataSubmissionStandingOrderExample.json.html#root)**

**☛ See [Full Data Profile](StructureDefinition-cgm-data-submission-standing-order.html#profile)**

{{ site.data.resources["StructureDefinition/cgm-data-submission-standing-order"].description }}

**Technical Details**

* CGM Submitters SHOULD respect the Receivers' submission preferences
* CGM Receivers MAY reject
  * An entire submission Bundle (e.g., if the frequency of submissions is too high)
  * Any subset of a submission Bundle (as documented above)

### SMART Health Links for CGM Data Sharing

The Data Submission protocol defined above enables standardized integration between CGM data sources and receiving systems like EHRs. However, there are situations where tight integration is not feasible or desired. [SMART Health Links](https://docs.smarthealthit.org/smart-health-links/) (SHLinks) provide a complementary method for sharing CGM data and reports among patients, caregivers, clinicians, and other authorized parties. SHLinks allow users to easily share selected subsets of CGM data as needed, offering an always up-to-date data feed without the need for direct system integration between the sharing parties. Specific scenarios where SHLinks provide value include:

- Sharing with parties that cannot or do not integrate with the Data Submission protocol, such as schools, camps, temporary caregivers during travel, etc.
- Allowing patients granular control over what specific data is shared and with whom, beyond just provider-patient contexts.
- Providing a simple, accessible sharing method for non-technical users like patients and caregivers.
- Enabling temporary data sharing for finite needs like referrals, research studies, or consultations.

By defining a tightly-orchestrated Data Submission API as well as a more loosely-coupled SHLinks capability, this IG ensures comprehensive interoperability that accommodates diverse real-world requirements across the CGM data sharing landscape.

#### Actors

**SHLink Creator:** A system that can generate SHLinks containing CGM data and reports, acting as a SHLink Sharing Application.

**SHLink Receiver:** A system that can receive and process SHLinks containing CGM data and reports, acting as a SHLink Receiving Application.  

#### Workflow

1. The SHLink Creator allows the user to select the desired CGM data and reports to share, as well as the time period to include. Options include:
   - Data to include: CGM Summary, CGM Sensor Readings, CGM Devices
   - Time period: Past 2 weeks, 1 month, 3 months, etc.
   - Link expiration time, if any

2. The SHLink Creator generates a SHLink containing the user-selected content, encrypted with a unique key.

3. The user shares the SHLink with the intended recipient(s), who use a SHLink Receiver to periodically access the shared data and stay up-to-date over time.  

4. The shared data conforms to the CGM Data Submission profiles, promoting interoperability and accessibility across different systems and platforms.


### Note on LOINC Codes

This IG aims to use LOINC codes for all Observations and DiagnosticReports. However, LOINC does not currently define codes for all required concepts.  We have therefore established the following approach:

* **Temporary CodeSystem:** [CodeSystem/cgm-summary-codes-temporary](CodeSystem-cgm-summary-codes-temporary.html#root) represents all concepts used by our resources.  Resource instances include these temporary codes + (whenever possible) equivalent LOINC codes.
* **ConceptMap:** [ConceptMap/CGMSummaryToLoinc](ConceptMap-CGMSummaryToLoinc.html#root) provides mappings between the temporary CodeSystem and existing LOINC codes (for the concepts with available codes).
* **Deprecation Planning:** We will deprecate this CodeSystem when LOINC support exists for the required concepts.

#### Overview of LOINC Mappings
<!-- {% raw %} 
Since the comment field does not exist in ConceptMappings this SQL cannot be used right now so just manuaully construct the table

{% sqlToData mappingCodes SELECT
  c.code as "Temporary Code",
  CASE
    WHEN cm.TargetCode IS NOT NULL THEN cm.TargetCode
    ELSE 'No LOINC Available'
  END as "LOINC Code"
FROM
  Concepts c
JOIN Resources r ON c.ResourceKey = r.key
LEFT JOIN ConceptMappings cm ON c.code = cm.SourceCode AND cm.SourceSystem LIKE '%cgm-summary-codes-temporary'
WHERE
  r.json->>'$.url' LIKE '%temporary'
%}

{% assign mappedCodes = 0 %}
{% assign unmappedCodes = 0 %}
{% for row in mappingCodes %}
  {% if row["LOINC Code"] == "No LOINC Available" %}
    {% assign unmappedCodes = unmappedCodes | plus: 1 %}
  {% else %}
    {% assign mappedCodes = mappedCodes | plus: 1 %}
  {% endif %}
{% endfor %}

##### Mapping Overview

- Total Concepts Required: {{ mappingCodes.size }}
  - **Mapped**: {{ mappedCodes }}
  - **Unmapped**: {{ unmappedCodes }}

##### Mapping Table

| Temporary Code | LOINC Code |
|----------------|------------|
{% for row in mappingCodes -%}
| {{ row["Temporary Code"] }} | {{ row["LOINC Code"] }} | {{ row["LOINC Comment"] }} |
{% endfor %}

{% endraw %} -->


|Temporary Code|LOINC Code|Expected LOINC Publication Date
|---|---|---|
|cgm-summary|104643-2|February 2025|
|mean-glucose-mass-per-volume|97507-8|Published|
|mean-glucose-moles-per-volume|105273-7|February 2025|
|times-in-ranges|No LOINC Available|LOINC submission pending. Expected publication date unknown
|time-in-very-low|104642-4|February 2025|
|time-in-low|104641-6|February 2025|
|time-in-target|97510-2|Published|
|time-in-high|104640-8|February 2025|
|time-in-very-high|104639-0|February 2025|
|gmi|97506-0|Published|
|cv|104638-2|Published|
|days-of-wear|104636-6|February 2025|
|sensor-active-percentage|104637-4|February 2025|
{:.grid}

### Package Downloads

{% include cross-version-analysis.xhtml %}
