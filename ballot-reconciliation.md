# Ballot Reconciliation - CGM IG

## [FHIR-49858](https://jira.hl7.org/browse/FHIR-49858): Add lookback option for "all" - REVERTED

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Cooper Thompson
**Status:** Reverted (was previously Applied)
**Resolution:** Reverted in favor of One-Time Order approach

**Description:**
We are looking a way to get relevant CGM data "on demand" rather than on a schedule. The SR currently has a lookbackPeriod. We'd like a clear way to ask for "all" data for the patient. One option is to just say to use the patient's birthday as the lookback start period. But I wanted to get a ticket in to formalize that if it makes sense. Another option is to just add another child extension that directly represents "lookback=forever".

**Rationale & Actions Taken:**
The previously implemented `lookbackAll` boolean extension was removed from the `DataSubmissionSchedule` extension. Instead, a new approach using a One-Time Order profile was implemented to address both FHIR-49858 and FHIR-49857 requirements in a unified solution.

The `lookbackAll` element was removed from:
- `Extension: DataSubmissionSchedule` definition in `input/fsh/profiles.fsh`
- All related documentation and examples

**Files Changed:**
*   `input/fsh/profiles.fsh` (removed lookbackAll extension)
*   `ballot-reconciliation.md` (removed original FHIR-49858 entry)

**Commit Message Suggestion:**
```
Revert FHIR-49858: Remove lookbackAll from Standing Order

- Removes lookbackAll boolean element from DataSubmissionSchedule extension.
- Unified solution implemented via One-Time Order profile instead.
```

---

## TODO(Josh Mandel): Add a generic profile for one-time order - IMPLEMENTED

**Description:**
Add a generic profile for one-time order, and have the CGM one-time order inherit from it, just as we do with the standing order profiles.

**Rationale & Actions Taken:**
Created a generic `DataSubmissionOneTimeOrder` profile that serves as the base for `CGMDataSubmissionOneTimeOrder`, mirroring the existing pattern where `DataSubmissionStandingOrder` serves as the base for `CGMDataSubmissionStandingOrder`.

**Changes Made:**
1. **New Generic Profile:** `DataSubmissionOneTimeOrder` - A base profile for one-time orders that specify an absolute time period for data collection
2. **Updated CGM Profile:** Modified `CGMDataSubmissionOneTimeOrder` to inherit from the new generic profile instead of directly from `ServiceRequest`
3. **Maintained Field Descriptions:** Ensured the CGM profile retains all field descriptions and documentation for proper rendering in the viewer

**Files Changed:**
*   `input/fsh/profiles.fsh` (added generic profile, updated CGM profile)

**Commit Message:**
```
Add generic DataSubmissionOneTimeOrder profile

- Creates DataSubmissionOneTimeOrder as base profile for one-time orders
- Updates CGMDataSubmissionOneTimeOrder to inherit from generic profile
- Maintains existing pattern used by standing order profiles
- Retains full field descriptions for proper viewer rendering

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## [FHIR-51515](https://jira.hl7.org/browse/FHIR-51515): Add Must Support definition and clarify molar/mass units - IMPLEMENTED

**Description:**
Add Must Support (MS) definition to the specification and clarify that while molar and mass units are not labeled as MS, conformant implementations must support at least one of these options.

**Rationale & Actions Taken:**
Added a comprehensive Must Support section to the main specification page that defines MS requirements for data submitters and receivers. Clarified the specific application of MS to the CGM Data Submission Bundle and removed MS flags from molar vs mass unit alternatives while maintaining the requirement that implementations support at least one option.

**Changes Made:**
1. **Added Must Support Section:** New section in main page defining MS requirements for submitters and receivers
2. **Clarified Bundle MS Usage:** Explained that MS on CGM Data Submission Bundle indicates which resource types submitters need to be capable of submitting
3. **Molar/Mass Units:** Removed MS flags from both molar and mass glucose unit alternatives in CGMDataSubmissionBundle and CGMSummaryObservation profiles
4. **Implementation Guidance:** Added note that conformant implementations must support at least one of the molar or mass unit options

**Files Changed:**
*   `input/pagecontent/index.md` (added Must Support section)
*   `input/fsh/profiles.fsh` (removed MS from molar/mass unit alternatives)

---

## [FHIR-49857](https://jira.hl7.org/browse/FHIR-49857): Describe option to push ServiceRequest - ADDRESSED via One-Time Order Profile

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Cooper Thompson
**Status:** Resolved - Applied via One-Time Order Profile
**Resolution:** Addressed through new One-Time Order profile

**Description:**
We are looking at a scenario where we (EHRs) want to push the ServiceRequest to the CGM data store, telling the CGM vendor to start sending us data. For example, if we have a standing order to get data every two weeks, but the patient is coming in 10 days into that two week window, we want to trigger the CGM vendor to send us the data they have "now".

**Rationale & Actions Taken:**
Instead of implementing a complex push mechanism, a new One-Time Order profile was created to address the underlying need for on-demand data requests. This approach provides:

1. **New Profile:** `CGMDataSubmissionOneTimeOrder` - A ServiceRequest profile for one-time data requests
2. **New Extension:** `DataSubmissionOneTimeSpec` - Contains absolute time period (FHIR Period) and data profiles
3. **New Code:** `cgm-data-submission-one-time-order` - Code system entry for one-time orders
4. **Documentation:** Added comprehensive documentation section explaining one-time orders
5. **Examples:** Created examples showing request for all of 2024 raw sensor data and 30-day summary data
6. **Data Chunking:** Added guidance for breaking large time period requests into meaningful chunks
7. **Required Period Fields:** Made Period start and end dates required (1..1 MS) for precise time specification
8. **OOB Transmission:** Documented that transmission mechanism is out-of-band, may include direct API calls triggered by automated logic or explicit user actions

This solution provides a standardized way to request CGM data for specific time periods without the complexity of real-time push mechanisms, while leaving transmission methods flexible for implementers.

**Files Changed:**
*   `input/fsh/profiles.fsh` (new profiles and extensions)
*   `input/fsh/examples.fsh` (new example)
*   `input/pagecontent/index.md` (new documentation section)

**Commit Message Suggestion:**
```
Fixes FHIR-49857: Add One-Time Order profile for on-demand CGM data requests

- Adds CGMDataSubmissionOneTimeOrder profile on ServiceRequest.
- Adds DataSubmissionOneTimeSpec extension with Period and data profiles.
- Adds cgm-data-submission-one-time-order code to CGM CodeSystem.
- Adds comprehensive documentation and example.
- Documents OOB transmission mechanism for one-time orders.
```

---

## [FHIR-50743](https://jira.hl7.org/browse/FHIR-50743): Replace temporary code system codes with the approved LOINC codes as requested.

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Gay Dolin
**Status:** Triaged (Proposing: Persuasive with Modification)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
The February 2025 LOINC publication has been released, and the relevant LOINC codes are now available. Please replace the temporary code system codes with the published LOINC codes in the profiles. Remove all associated mapping tables unless any requested codes remain outstanding.

**Proposed Disposition:** Persuasive with Modification.

**Rationale & Actions Taken:**
The LOINC February 2025 release (specifically version 2.80) was reviewed. Most temporary codes used in the CGM IG now have active LOINC equivalents. One new LOINC panel code for "times-in-ranges" was also identified and adopted. The `cgm-summary` concept's LOINC equivalent (104643-2) is still pending publication.

The following changes were implemented:

1.  **In `input/fsh/profiles.fsh`:**
    *   `CodeSystem: CGMSummaryCodesTemporary`: Updated to retain only the `#cgm-summary` code, as its LOINC equivalent `104643-2` is not yet active. All other temporary codes were removed. The description was updated to reflect this.
    *   `Instance: CGMSummaryToLoinc` (ConceptMap): Updated to map only the remaining temporary code `#cgm-summary` to its pending LOINC equivalent `104643-2`. The description was updated.
    *   `Profile: CGMSummaryTimesInRanges`: The `code` element was changed from `CGMSummaryCodesTemporary#times-in-ranges` to use a new inline `Instance: TimesInRangesLoinc`.
    *   Added `Instance: TimesInRangesLoinc` defined with `* coding[+] = $LNC#106793-3` ("Continuous glucose monitoring time in ranges panel").
    *   All other inline `CodeableConcept` instances (e.g., `MeanGlucoseMassPerVolumeWithLoinc`, `GMIWithLoinc`, `TimeInVeryLowWithLoinc`, `TimeInLowWithLoinc`, `TimeInTargetWithLoinc`, `MeanGlucoseMolar`, `TimeInHighWithLoinc`, `TimeInVeryHighWithLoinc`, `CVWithLoinc`, `DaysOfWearWithLoinc`, `SensorActivePercentageWithLoinc`) were updated to remove the line referencing `CGMSummaryCodesTemporary#...` and now directly use their respective active `$LNC#...` codes. Commented-out LOINC lines were activated.

2.  **In `input/pagecontent/index.md`:**
    *   The "Note on LOINC Codes" narrative section was updated to explain that most temporary codes have been replaced with official LOINC codes, and only `cgm-summary` remains temporary.
    *   The "Overview of LOINC Mappings" table was revised to:
        *   Reflect the current status of all concepts (mostly "Published", one "Pending LOINC Publication").
        *   Include the new LOINC panel code `106793-3` for "Times in Glucose Ranges (Panel)".
        *   Clearly indicate which temporary codes were replaced by which LOINC codes.

**Files Changed:**
*   `input/fsh/profiles.fsh`
*   `input/pagecontent/index.md`

**Commit Message Suggestion:**
```
Fixes FHIR-50743: Update IG with published LOINC codes

- Modifies CGMSummaryCodesTemporary to retain only cgm-summary.
- Updates CGMSummaryToLoinc ConceptMap accordingly.
- Replaces temporary times-in-ranges with new LOINC panel 106793-3.
- Updates relevant profiles and inline CodeableConcepts to use active LOINC codes.
- Revises LOINC notes and mapping table in index.md.
```

---

## [FHIR-50742](https://jira.hl7.org/browse/FHIR-50742): Please add acknowledgments or authors section

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Gay Dolin
**Status:** Triaged (Proposing: Persuasive)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
Please add an Acknowledgments or Authors section that includes the primary editors, key project participants, and their affiliations. If appropriate, consider including contact email addresses for follow-up or inquiries. If the project has a project confluence or other web page, please include a link to the page.

**Proposed Disposition:** Persuasive.

**Rationale & Actions Taken:**
An "Acknowledgments" section was added to the bottom of the main page (`input/pagecontent/index.md`).

The section includes:
*   A general thank you statement.
*   A link to the project's Confluence page: [FHIR Write - CGM](https://confluence.hl7.org/spaces/AP/pages/234784555/FHIR+Write+-+CGM).
*   **Primary Editors:**
    *   Josh Mandel (SMART Health IT, Microsoft)
    *   Eric Haas (Health eData Inc)
*   **Key Contributors:**
    *   Specific acknowledgment for Mikael Rinnetmäki (Sensotrend Oy).
    *   Specific acknowledgment for Brett Marquard (WaveOne Associates).
    *   Specific acknowledgment for Marti Velezis.
    *   A general statement recognizing contributions from various organization types involved in the Argonaut Project (CGM device vendors, app developers, EHRs, patient advocates, clinicians).

**Files Changed:**
*   `input/pagecontent/index.md`

**Commit Message Suggestion:**
```
Fixes FHIR-50742: Update Acknowledgments section in IG

- Adds Brett Marquard and Marti Velezis to Key Contributors.
- Updates index.md and ballot-reconciliation.md.
```

---

## [FHIR-50709](https://jira.hl7.org/browse/FHIR-50709): Inpatient user story

**Project:** FHIR Specification Feedback
**Type:** Question
**Priority:** Medium
**Reporter:** Lynn Perrine (on behalf of Nadine Shehab)
**Status:** Resolved - No Change (Verified)
**Resolution:** Considered - Question answered

**Description:**
It would be beneficial to cite a use case specific to a CGM app connecting to the inpatient EHR for patients on these devices who are hospitalized. In those cases, it is not clear if the data trigger or nominal workflow would be the same? For example, in the inpatient EHR example, how is real-time integration accounted for? In the "scheduled submission interval" or some other way? Quality measures for hospital glycemic control will require access to CGM data--already integrated into the EHR once the patient is admitted. Would the workflow account for that or would additional considerations be needed?

**Disposition Justification (from JIRA):**
This is a great question - Would you consider submitting this comment for the Personal Health Devices STU? (https://hl7.org/fhir/uv/phd/ProfileConsumers.html) Developing broadly applicable guidance for patient devices in an Inpatient setting would be wise!

**Action Taken:**
None. The issue was deemed out of scope for the CGM IG and more appropriate for the Personal Health Devices (PHD) IG. No changes were made to the CGM IG as a result of this ticket.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-50566.
```

---

## [FHIR-50562](https://jira.hl7.org/browse/FHIR-50562): Minor question related to linked narrative content

**Project:** FHIR Specification Feedback
**Type:** Question
**Priority:** Medium
**Reporter:** Lynn Perrine
**Status:** Triaged (Proposing: Persuasive)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
The link in section 2.22.1 Entry 2 is "Observation Times in Glucose Ranges" but the header in section 2.28.1 Narrative Content that it links to reads "CGM Summary Times in Ranges Example". Consider either adding 'Summary' before times in the URL name in 2.22.1 to remove ambiguity (so it would read "Observation Summary Times in Glucose Ranges") or remove 'Summary' from the header in section 2.28.1 so it reads "CGM Times in Ranges Example".

**Proposed Disposition:** Persuasive.

**Rationale & Actions Taken:**
The discrepancy noted is due to the FHIR IG publisher's default logic, which can render link text for Observation resources based on their codes or other properties, rather than strictly from example titles or profile titles. This can lead to differences between the displayed link text and the title of the target page.

To address the commenter's suggestion of making the example title "CGM Times in Ranges Example" (by removing "Summary"), the `Title` of the `Profile: CGMSummaryTimesInRanges` in `input/fsh/profiles.fsh` was changed from "CGM Summary Times in Ranges" to "CGM Times in Ranges". This change will propagate to the generated title of the example page (`Observation-cgmSummaryTimesInRangesExample.json.html`), aligning it with the second option proposed in the JIRA ticket. While the profile still inherently deals with summary data, this change directly addresses the naming inconsistency highlighted for the example.

**Files Changed:**
*   `input/fsh/profiles.fsh`

**Commit Message Suggestion:**
```
Fixes FHIR-50562: Align example title for Times in Ranges

- Changes Title of Profile: CGMSummaryTimesInRanges to
  "CGM Times in Ranges" in profiles.fsh.
- This addresses a reported discrepancy between link text and
  the example page title by modifying the profile title, which
  influences the generated example page title.
```

---

## [FHIR-50564](https://jira.hl7.org/browse/FHIR-50564): Header language discrepancy in various sections

**Project:** FHIR Specification Feedback
**Type:** Question
**Priority:** Medium
**Reporter:** Lynn Perrine
**Status:** Triaged (Proposing: Persuasive)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
Discrepancy between Sections 1.6, 2.14.1, and 2.33.1. The profile link in section 1.6 says "Glucose Management Index" but the 2.14.1 resource Profile says "Resource Profile: Glucose Management Indicator (GMI)" and the 2.33.1 Example Observation GMI Example says Glucose Management Indicator. Should section 1.6 be revised to Indicator rather than Index?

**Proposed Disposition:** Persuasive.

**Rationale & Actions Taken:**
Confirmed that "Glucose Management Indicator" is the correct term. The inconsistency was found in the `Description` of the `Profile: CGMDataSubmissionBundle` within `input/fsh/profiles.fsh`. This description is dynamically included in `input/pagecontent/index.md`.

The term "Glucose Management Index" was changed to "Glucose Management Indicator" in the `Description` of `Profile: CGMDataSubmissionBundle` in `input/fsh/profiles.fsh`. This will ensure consistent terminology when the IG is published.

**Files Changed:**
*   `input/fsh/profiles.fsh`

**Commit Message Suggestion:**
```
Fixes FHIR-50564: Correct GMI term to "Indicator"

- Changed "Glucose Management Index" to "Glucose Management Indicator"
  in the description of Profile: CGMDataSubmissionBundle in
  profiles.fsh for consistency.
```

---

## [FHIR-50708](https://jira.hl7.org/browse/FHIR-50708): add a explicit warning on the transaction bundle handling

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Patrick Werner
**Status:** Triaged (Proposing: Persuasive)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
The IG should explicitly warn implementers about the potential risks of accepting arbitrary transaction Bundles. It should recommend or require that servers receiving CGM transaction Bundles implement strict whitelisting or validation rules, ensuring that only POST operations for CGM-relevant resource types (e.g., Observation, Device, Patient) are allowed.

**Proposed Disposition:** Persuasive.

**Rationale & Actions Taken:**
A new point was added to the "CGM Data Receivers" technical details list in the "CGM Data Submission: Bundles" section of `input/pagecontent/index.md`.
  
This addition includes:
*   A `SHOULD` recommendation for receivers to implement strict validation and whitelisting rules for incoming `$submit-cgm-bundle` transactions.
*   Specific examples of rules:
    *   Permitting only `POST` operations.
    *   Allowing only CGM-relevant resource types (e.g., `Observation`, `Device`, `Patient`, `DiagnosticReport`, `ServiceRequest`).
    *   Ensuring submissions pertain to the correct patient context.
    *   Rejecting bundles with disallowed operations or types.
*   A distinct "> **Warning:**" block emphasizing the security risk of processing arbitrary transaction Bundles without proper validation.

**Files Changed:**
*   `input/pagecontent/index.md`

**Commit Message Suggestion:**
```
Fixes FHIR-50708: Add warning for transaction bundle handling

- Adds recommendations and a warning to CGM Data Receiver technical
  details regarding validation of incoming transaction bundles.
- Suggests whitelisting operations, resource types (Observation,
  Device, Patient, DiagnosticReport, ServiceRequest), and
  validating patient context.
```

---

## [FHIR-50560](https://jira.hl7.org/browse/FHIR-50560): Questions about the workflow diagram

**Project:** FHIR Specification Feedback
**Type:** Question
**Priority:** Medium
**Reporter:** Lynn Perrine
**Status:** Triaged (Proposing: Persuasive with Modification)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
1. Do the borders around some of the flowchart signify something or is it simply to show the steps involved for each process along the way (e.g., app authorization vs establish EHR patient ID vs learn submission preferences vs submission triggers)?
2. Bullet #2 includes FHIR patient search but I don't see that on the flow diagram. Is it missing in the flow diagram or is it inferred for those with a deeper understanding of FHIR and CGM workflow?

**Proposed Disposition:** Persuasive with Modification.

**Rationale & Actions Taken:**

1.  **Regarding borders:** The borders in the workflow diagram (`input/images-source/flow.plantuml`, which generates `flow.svg`) are created using PlantUML's `partition` keyword. These are used for visually grouping related steps into logical phases (e.g., "App Authorization", "Establish EHR Patient ID"). This is a standard diagramming practice for clarity and does not imply additional semantics beyond grouping. No textual clarification is deemed necessary for this aspect.

2.  **Regarding FHIR Patient Search:** The narrative text for step 2 of the Nominal Workflow ("Establish EHR Patient ID") correctly lists "through FHIR patient search" as one of the methods. The workflow diagram previously showed "Obtain patient ID out-of-band" as the alternative if the ID wasn't in the authorization context. To better align the diagram with the text and address the comment, the diagram was updated.
    *   In `input/images-source/flow.plantuml`, the step for obtaining patient ID when not in authorization context was changed from `:Obtain patient ID out-of-band;` to `:Obtain patient ID (e.g., FHIR Patient Search, or other out-of-band method);`. This explicitly includes "FHIR Patient Search" as an example in the diagram, making it more consistent with the detailed textual description.

**Files Changed:**
*   `input/images-source/flow.plantuml`

**Commit Message Suggestion:**
```
Fixes FHIR-50560: Clarify workflow diagram re FHIR Patient Search

- Updates flow.plantuml to explicitly mention "FHIR Patient Search"
  as an example method for obtaining Patient ID in the diagram.
- This aligns the diagram more closely with the detailed text in the
  Nominal Workflow section.
- Addresses questions about diagram borders (visual grouping) and
  the representation of FHIR Patient Search.
```

---

## [FHIR-50470](https://jira.hl7.org/browse/FHIR-50470): Consider defining value for verylow, low, high and veryhigh for the Observation.component: timeIn...

**Project:** FHIR Specification Feedback
**Type:** Comment
**Priority:** Medium
**Reporter:** Rebecca Baker
**Status:** Resolved - No Change (Verified from JIRA)
**Resolution:** Considered - No action required (Verified from JIRA)

**Description:**
Consider defining what "Very Low Range"; "Low Range" "High Range" and "Very High Range" mean. It seems that "Target range" would be the normal glucose range. This will ensure that the comparison of the ranges in the percentage time are equivalent.
(Related URL: https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-times-in-ranges.html)

**Disposition Justification (from JIRA):**
The CGM project requested and received LOINC concepts post ballot which includes the reference range in the definition - for example (https://loinc.org/104642-4/):
Amount of time, in percent, as measured by CGM (continuous glucose monitor) device, spent below target glucose range, very low (TBR-VL) <54 mg/dL (<3.0 mmol/L) (hypoglycemic) during reporting period.

**Action Taken:**
None. The definitions for these ranges are provided by the LOINC codes themselves, which are now used in the IG (as addressed in FHIR-50743). Therefore, no additional definitions are needed within this IG.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-50470.
```

---

## [FHIR-50450](https://jira.hl7.org/browse/FHIR-50450): Improve sclicing?

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Gabriel Kleinoscheg
**Status:** Triaged (Proposing: Persuasive with Modification)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
In https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-data-submission-bundle.html#profile there are slices which do not specify a specific profie. This could be mis... (description truncated, refers to an image in JIRA)

**Proposed Disposition:** Persuasive with Modification.

**Rationale & Actions Taken:**
The primary issue addressed was a copy-paste error within the `Profile: CGMDataSubmissionBundle` definition in `input/fsh/profiles.fsh`. An erroneous `device 0..* MS and` line was present within the `entry[observation] contains` block, which has been removed.

Regarding the main comment about "slices which do not specify a specific profile":
The `Bundle.entry` slices in `CGMDataSubmissionBundle` use a combination of type-based slicing (discriminator `resource`) and value-based slicing for Observations (discriminator `resource.ofType(Observation).code`). This approach is intentional to allow for performant validation by enabling tools to quickly identify the type of resource in an entry and then, for Observations, the specific kind of observation based on its code.

The rendering of these slices in the IG's differential tree view (e.g., showing a generic "entry:observation" slice before the specifically typed Observation slices like "entry:observation:cgmSummary") can sometimes appear as if a profile constraint is missing at the initial "entry:observation" level. This is understood to be a characteristic of the IG publishing tooling when handling complex, multi-discriminator slicing. The actual constraints are applied at the more specific named slices (e.g., `entry[observation][cgmSummary].resource only CGMSummaryObservation`).

No further changes to slicing definitions were made beyond the correction of the copy-paste error, as the current slicing logic is by design.

**Files Changed:**
*   `input/fsh/profiles.fsh` (for the copy-paste error correction)

**Commit Message Suggestion:**
```
Fixes FHIR-50450: Correct slicing error in CGMDataSubmissionBundle

- Removes an erroneous 'device' slice from within the
  'entry[observation] contains' block in profiles.fsh. This was
  a copy-paste error.
- Documents rationale for type-based slicing approach and clarifies
  that the rendering of generic slices in the IG tree is a tooling
  characteristic.
```

---

## [FHIR-50350](https://jira.hl7.org/browse/FHIR-50350): Update LOINC mapping table to indicate codes have been published and remove use of the temporary codes

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Rob McClure
**Status:** Triaged (Proposing: Considered - Duplicate)
**Resolution:** Unresolved (Proposing: Resolved - Duplicate)

**Description:**
It would be preferable that you remove all the temporary codes that are now real LOINC codes from the profiles and examples. Instead only use the real codes. It is fine to maintain the "old" temporary codes in the mapping table to provide a lineage to prior work - although if that was never published, you could remove all references to the temporary codes in the final publication - a preferable solution.

**Proposed Disposition:** Considered - Duplicate.

**Rationale & Actions Taken:**
This ticket is considered a duplicate of [FHIR-50743](https://jira.hl7.org/browse/FHIR-50743). The actions taken for FHIR-50743 (updating profiles to use official LOINC codes, revising the temporary CodeSystem and ConceptMap, and updating narrative sections) comprehensively address the requests in this ticket. No separate actions are required for FHIR-50350.

**Files Changed:**
*   None (Covered by FHIR-50743).

**Commit Message Suggestion:**
```
No commit needed for FHIR-50350 (Duplicate of FHIR-50743).
```

---

## [FHIR-50213](https://jira.hl7.org/browse/FHIR-50213): valueQuantity cardinality fixed to 1:1 in CGM Sensor Reading profiles

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Jacob Andersen
**Status:** Triaged (Proposing: Persuasive with Modification)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
As far as I understand this implementation guide, the purpose of the two "CGM Sensor Reading" profiles is to communicate the original (non-aggregated) sensor readings. Fixing the .value cardinality at 1:1 becomes a problem when the CGM device reports an error or when the reading is out of range. According to IEEE 11073-10425-2023 §6.7.2: "A glucose measurement that is above the capabilities of the device sensor shall be indicated with an observed value of +INFINITY, and a glucose measurement that is below the capabilities of the device sensor shall be indicated with an observed value of -INFINITY" and according to the "Bluetooth Continuous Glucose Monitoring Service" v1.0.2 § 3.10: "NaN is used to report an invalid result from a computation step or to indicate missing data due to the hardware ́s inability to provide a valid measurement, perhaps from sensor perturbation". These values cannot be mapped into the .valueQuantity element, however, ignoring them could be a major problem. According to the Personal Health Devices IG https://hl7.org/fhir/uv/phd/2024Sep/MderFLOATsandSFLOATs.html#special-values these special values must be mapped to .dataAbsentReason (with NO .value[x] element!). I propose aligning these profiles with the PhdNumericObservation profile https://hl7.org/fhir/uv/phd/2024Sep/StructureDefinition-PhdNumericObservation.html by setting the .value[x] cardinality to 0:1 and possibly add some text explaining the use of the .dataAbsentReason element and/or a constraint that one of these two elements must be present.

**Proposed Disposition:** Persuasive with Modification.

**Rationale & Actions Taken:**
The `valueQuantity` cardinality in the `CGMSensorReadingMassPerVolume` and `CGMSensorReadingMolesPerVolume` profiles was changed from `1..1` to `0..1`. This was achieved by modifying the `GlucoseMassPerVolume` and `GlucoseMolesPerVolume` RuleSets in `input/fsh/profiles.fsh`.
Additionally, a new invariant `cgm-sensor-value-or-dar` was defined and applied to both sensor reading profiles.
*   **Invariant:** `cgm-sensor-value-or-dar`
*   **Description:** "A sensor reading must have a valueQuantity or a dataAbsentReason."
*   **Expression:** `value.exists() or dataAbsentReason.exists()`
*   **Severity:** `#error`
These changes allow sensor readings to omit `valueQuantity` if a `dataAbsentReason` is provided, accommodating error conditions or special values as described in the ticket and aligning better with PHD IG practices.

**Files Changed:**
*   `input/fsh/profiles.fsh`

**Commit Message Suggestion:**
```
Fixes FHIR-50213: Modify CGM Sensor Reading profiles for dataAbsentReason

- Changes valueQuantity cardinality to 0..1 in CGMSensorReadingMassPerVolume
  and CGMSensorReadingMolesPerVolume profiles (via RuleSet modification).
- Adds invariant cgm-sensor-value-or-dar to these profiles, requiring
  value.exists() or dataAbsentReason.exists().
- This aligns with PHD IG for handling special sensor values/errors.
```

---

## [FHIR-50197](https://jira.hl7.org/browse/FHIR-50197): Clarify requirement for short time periods

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Craig Newman
**Status:** Triaged (Proposing: Persuasive)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
The CGM ServiceRequest profile discusses how the DataSubmissionSchedule extension includes a submissionPeriod and lookbackPeriod, both of which are explicitly called out as using days, weeks, months or years. However the value set used in the extension itself points to a value set that also includes seconds, minutes and hours. Please clarify if the extension supports these shorter periods.

**Proposed Disposition:** Persuasive.

**Rationale & Actions Taken:**
The narrative description for `submissionPeriod` and `lookbackPeriod` within the `DataSubmissionSchedule` extension (part of the `CGMDataSubmissionStandingOrder` profile) in `input/fsh/profiles.fsh` was updated.
The previous description only mentioned units of days, weeks, months, or years.
The updated description now explicitly states that these elements are Quantities with units bound to the [UnitsOfTime](http://hl7.org/fhir/ValueSet/units-of-time) value set, which allows for `s` (seconds), `min` (minutes), `h` (hours), `d` (days), `wk` (weeks), `mo` (months), and `a` (years).
A note was also added that while shorter units are technically permissible, common practice for CGM data submission schedules typically involves longer durations such as days, weeks, or months. This clarifies that the system supports shorter periods as per the value set.

**Files Changed:**
*   `input/fsh/profiles.fsh`

**Commit Message Suggestion:**
```
Fixes FHIR-50197: Clarify supported units for submission/lookback periods

- Updates description of DataSubmissionSchedule in CGMDataSubmissionStandingOrder
  profile (profiles.fsh) to clarify that submissionPeriod and lookbackPeriod
  support all units from ValueSet/units-of-time (s, min, h, d, wk, mo, a).
- Adds a note about common practice typically using longer durations.
```

---

## [FHIR-50196](https://jira.hl7.org/browse/FHIR-50196): typo

**Project:** FHIR Specification Feedback
**Type:** Technical Correction
**Priority:** Lowest
**Reporter:** Craig Newman
**Status:** Triaged (Proposing: Persuasive)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
Home - Section 1.6 Handling Duplicate Submissions - The Server-Side Deduplication has odd indenting. The Return 200 and Return 201 should probably be indented relative to the line above and there should probably be a new line starting with "Servers SHAL document their deduplication..."

**Proposed Disposition:** Persuasive.

**Rationale & Actions Taken:**
The formatting of the "Server-Side Deduplication" subsection under "Handling Duplicate Submissions" in `input/pagecontent/index.md` was reviewed.
1.  The list items "Return a 200 OK status..." and "Return a 201 Created status..." were further indented to make them clear sub-items of the preceding line "When duplicates are detected, servers SHOULD either:".
2.  The line "Servers SHALL document their deduplication strategy in their developer documentation" already started on a new line as a distinct bullet point, which is appropriate for its content. No change was needed for this specific point beyond ensuring standard list rendering.

These changes improve the readability of the Markdown list structure.

**Files Changed:**
*   `input/pagecontent/index.md`

**Commit Message Suggestion:**
```
Fixes FHIR-50196: Correct indentation in Server-Side Deduplication section

- Adjusts indentation for list items under "Server-Side Deduplication"
  in input/pagecontent/index.md for improved clarity.
```

---

## [FHIR-50084](https://jira.hl7.org/browse/FHIR-50084): Add Attribution to Argonaut in Introduction

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Brett Marquard
**Status:** Applied (Verified from JIRA)
**Resolution:** Persuasive (Verified from JIRA)

**Description:**
Noticed we didn't have any link to Argonaut work! Add the following to end of introduction paragraph:
The requirements for this guide were initially developed in the Argonaut Project, with the input from patients, providers, CGM device vendors, app developer, and EHR systems and later in collaboration with the HL7 Orders and Observation Work Group.

**Rationale & Actions Taken:**
The JIRA ticket is marked "Applied". The "Introduction" section of `input/pagecontent/index.md` was reviewed and found to contain the exact text proposed in the JIRA ticket, including the link to the Argonaut Project confluence page.
No changes to the IG content were necessary.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-50084 (Already applied).
```

---

## [FHIR-49966](https://jira.hl7.org/browse/FHIR-49966): Remove all county-specific dependencies

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Jose Costa-Teixeira
**Status:** Applied (Verified from JIRA)
**Resolution:** Persuasive (Verified from JIRA)

**Description:**
This being an intenational IG, we should remove all dependencies from any country. (JIRA title implies "country-specific")

**Proposed Disposition (from JIRA Resolution Description):**
All US Core dependencies will be removed.

**Rationale & Actions Taken:**
The JIRA ticket is marked "Applied". The `sushi-config.yaml` file was reviewed. The `dependencies` section has the line for `hl7.fhir.us.core` commented out, confirming that US Core is not an active dependency for this IG. This aligns with the resolution to remove country-specific dependencies.
No changes to the IG content or configuration were necessary.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-49966 (Already applied).
```

---

## [FHIR-49965](https://jira.hl7.org/browse/FHIR-49965): Remove mandatory dependencies from SMART on FHIR and other infrastructure - should be out of scope

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Highest
**Reporter:** Jose Costa-Teixeira
**Status:** Applied (Verified from JIRA)
**Resolution:** Persuasive (Verified from JIRA)

**Description:**
Request to remove references to SMART on FHIR from nominal flow, and at least the first use case should not depend or rely on SMART on FHIR, but be a "basic" case and global. Ensure that the guidance focuses on content and is clearly readable - and oriented - for places where SMART-on-FHIR is not used.

**Proposed Disposition (from JIRA Resolution Description):**
SMART was never a direct dependency in the "package tree", and use was never mandatory; proposal is clarifying this in the narrative text; there are no technical profiles. Motion is to incorporate changes at: https://github.com/HL7/cgm/compare/HL7:7b5ac4b...HL7:2327708

**Rationale & Actions Taken:**
The JIRA ticket is marked "Applied" and "Pre Applied: Yes". The narrative text in `input/pagecontent/index.md` was reviewed.
*   In the "Nominal Workflow" section, step 1 ("App Authorization") mentions SMART App Launch and SMART Backend Services Authorization using "(e.g., ...)", indicating they are examples.
*   In "Establishing Connections" for "Patient App to EHR", SMART on FHIR is mentioned with "(e.g., SMART on FHIR)".
This phrasing clarifies that SMART on FHIR is an optional mechanism, not a mandatory dependency, aligning with the ticket's resolution. No further changes to the IG content were necessary.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-49965 (Already applied).
```

---

## [FHIR-48984](https://jira.hl7.org/browse/FHIR-48984): What Bundle.type should $submit-cgm-bundle request/response use?

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Josh Mandel
**Status:** Applied (Verified from JIRA)
**Resolution:** Persuasive with Modification (Verified from JIRA)

**Description:**
Current proposal uses Bundle.entry.request to convey details about conditionalCreate, but Bundle.entry.request is prohibited in transaction-response bundles. In R5+, using transaction and transaction-response works fine. But in R4, if we want to include .request and .response in the same Bundle, we'd need to use "history" bundles. Bottom line: document a strategy that is valid in R4 and beyond.

**Proposed Disposition (from JIRA Resolution Description):**
Instead of using history bundles...
1. Use transaction for requests and transaction-response for responses
2. Servers SHALL document their behavior out of band, in their developer documentation...

**Rationale & Actions Taken:**
The JIRA ticket is marked "Applied". The IG was reviewed to confirm alignment:
*   In `input/fsh/profiles.fsh`, the `Profile: CGMDataSubmissionBundle` (used for the request) correctly defines `* type = #transaction`.
*   In `input/fsh/profiles.fsh`, the `Instance: submit-cgm-bundle` (which is the `OperationDefinition`) states in its description and in the `parameter[return].documentation` that the output is a "Bundle of type 'transaction-response'".
The IG correctly reflects the resolution. No changes to the IG content were necessary.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-48984 (Already applied).
```

---

## [FHIR-48985](https://jira.hl7.org/browse/FHIR-48985): Link to PHD Observation.identifier guidance as an example for conditionalCreate

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Josh Mandel
**Status:** Applied (Verified from JIRA)
**Resolution:** Persuasive with Modification (Verified from JIRA)

**Description:**
We can link to https://build.fhir.org/ig/HL7/phd/StructureDefinition-PhdBaseObservation.html#observation-identifier---prevention-of-data-duplication to indicate that the CMG guidance is compatible with this approach.

**Proposed Disposition (from JIRA Resolution Description):**
From OO discussion: it may be confusing for developers to add links to PHD, since the IEEE identifiers required in PHD spec aren't likely to be available in the CGM use case. So instead of linking out to PHD, we can just say something like:
> Clients MAY adopt any strategy for generating Identifiers, including strategies to deterministically create identifiers based on the instance data

**Rationale & Actions Taken:**
The JIRA ticket is marked "Applied". The suggested text "> Clients MAY adopt any strategy for generating Identifiers, including strategies to deterministically create identifiers based on the instance data" was verified to be present in `input/pagecontent/index.md` under the "Client-Controlled Deduplication With Conditional Create" subsection of "Handling Duplicate Submissions".
No changes to the IG content were necessary.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-48985 (Already applied).
```

---

## [FHIR-48994](https://jira.hl7.org/browse/FHIR-48994): Specify behavior for servers that don't support conditional creates

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Mikael Rinnetmäki
**Status:** Triaged (Proposing: Persuasive - Already Applied)
**Resolution:** Not Persuasive with Modification (as per JIRA, but effectively Already Applied)

**Description:**
The fix for FHIR-48984 removed guidance for servers on what to do when they do not support conditional creates. We should at least recommend a behavior.

**Proposed Disposition:** Persuasive - Already Applied.

**Rationale & Actions Taken:**
The JIRA ticket's "Resolution Description" indicates "Pre Applied: Yes" and links to [pull request #16](https://github.com/HL7/cgm/pull/16).
The current text in `input/pagecontent/index.md` under "Handling Duplicate Submissions" states:
  "* When a server does not support conditional creates, it:
    * SHOULD NOT create resources for `Bundle.entry` elements that have the `ifNoneExist` element and, for each of these entries, respond with a status `400` in the response Bundle.
    * SHOULD create resources for other `Bundle.entry` elements according to other applicable rules."
This text aligns with the resolution described in the JIRA ticket. No further changes to the IG content are needed.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-48994 (Already applied).
```

---

## [FHIR-48995](https://jira.hl7.org/browse/FHIR-48995): ifNoneExists only takes the query string

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Mikael Rinnetmäki
**Status:** Triaged (Proposing: Persuasive - Already Applied)
**Resolution:** Unresolved (Proposing: Resolved - Applied)

**Description:**
The current specification says: Example of Bundle.entry.request.ifNoneExists: Observation?identifier=https://client.example.org|123. However, the value of the element should only contain the search parameters ("what would be in the URL following the '?'). See the spec. We should fix the example.

**Proposed Disposition:** Persuasive - Already Applied.

**Rationale & Actions Taken:**
The example for `Bundle.entry.request.ifNoneExist` in the "Handling Duplicate Submissions" section of `input/pagecontent/index.md` was reviewed. It currently reads `identifier=https://client.example.org|123`. This is the correct format as per the JIRA ticket's requirement (i.e., it does not include "Observation?").
A comment on the JIRA ticket (FHIR-48995) by Brett Marquard on 2025-02-18 states: "MikaelRinnetmäki fixed in https://github.com/HL7/cgm/pull/6 !"
This confirms the issue was already addressed in the IG source. No changes to `input/pagecontent/index.md` were necessary.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-48995 (Already applied).
```

---

## [FHIR-49857](https://jira.hl7.org/browse/FHIR-49857): Describe option to push ServiceRequest

**Project:** FHIR Specification Feedback
**Type:** Change Request
**Priority:** Medium
**Reporter:** Cooper Thompson
**Status:** Triaged (Proposing: Considered - Deferred)
**Resolution:** Unresolved (Proposing: Resolved - Deferred for Future Consideration)

**Description:**
We are looking at a scenario where we (EHRs) want to push the ServiceRequest to the CGM data store, telling the CGM vendor to start sending us data. For example, if we have a standing order to get data every two weeks, but the patient is coming in 10 days into that two week window, we want to trigger the CGM vendor to send us the data they have "now". Possible options: 1. Describe an option for the EHR to post a SR to the CGM data store. 2. Look at using subscription notifications so we notify the CGM data store to re-query the SR. 3. Others?

**Proposed Disposition:** Considered - Deferred for Future Consideration.

**Rationale & Actions Taken:**
This ticket proposes a significant new workflow where an EHR (Data Receiver) could initiate a data request or trigger a submission from a CGM Data Submitter. This is a reversal of the primary push model in the IG (Submitter pushes to Receiver). Addressing this fully would require substantial design discussion and potentially new profiles, operations, or actor capability definitions.

The following points are noted for future discussion when this capability is considered:
*   **Scope of Request:**
    *   Is the primary use case for one-off, on-demand data pushes (e.g., for an imminent appointment)?
    *   Or is it also intended for the EHR to establish or modify ongoing *scheduled* data submissions by pushing/updating a `ServiceRequest` to the Submitter?
*   **Mechanism for EHR-Initiated Action:**
    *   **Push ServiceRequest:** EHR POSTs/PUTs a `ServiceRequest` to a new endpoint on the CGM Data Submitter.
        *   *Considerations:* Requires defining this endpoint, how the Submitter discovers it, security/authorization for the EHR to call it, and how the Submitter interprets/acts on this (one-time fulfillment vs. updating a schedule).
    *   **Trigger Operation:** Define a specific operation (e.g., `$trigger-cgm-data-submission`) that the EHR can invoke on the CGM Data Submitter's system.
        *   *Considerations:* Parameters for the operation (e.g., patient identifier, reference to an existing `ServiceRequest` if applicable, specific data profiles if different from a standing order), synchronous vs. asynchronous behavior.
    *   **Subscription-based Trigger:** EHR updates a resource that the CGM Data Submitter is subscribed to (e.g., if the Submitter could subscribe to changes in the EHR's `ServiceRequest` for that patient).
        *   *Considerations:* Complexity of managing subscriptions, discovery of subscription topics.
*   **Actor Capabilities:** This would likely necessitate new capabilities for both Data Submitters (to receive/process such requests/triggers) and Data Receivers (to initiate them).
*   **Authorization Model:** The current IG's authorization model (Submitter authorized by Patient to write to EHR) would need to be extended or complemented to cover EHR-initiated requests to the Submitter. How does the Submitter authenticate/authorize the EHR?
*   **Priority/Optionality:** Would this be a core, required capability or an optional one?

Given the complexity and scope, this functionality is deferred for consideration in a future version of the IG. No changes were made to the specification in this version.

**Files Changed:**
*   None.

**Commit Message Suggestion:**
```
No commit needed for FHIR-49857 (Deferred for future consideration).
```

---
