Alias: $UCUM = http://unitsofmeasure.org
Alias: $LNC = http://loinc.org
Alias: $compliesWithProfile = http://hl7.org/fhir/StructureDefinition/structuredefinition-compliesWithProfile

RuleSet: ObservationBase
* subject 1..1 MS
  * ^short = "Patient for the report" 

RuleSet: DiagnosticReportBase
* subject 1..1 MS
  * ^short = "Patient for the report" 

RuleSet: GlucoseMassPerVolume
* value[x] only Quantity
* valueQuantity 0..1 MS
* valueQuantity = 'mg/dL' "mg/dl"
  * ^short = "Glucose value in mg/dL"

RuleSet: GlucoseMolesPerVolume
* value[x] only Quantity
* valueQuantity 0..1 MS
* valueQuantity = 'mmol/L' "mmol/l"
  * ^short = "Glucose value in mmol/L"

Profile: CGMSensorReadingMassPerVolume
Parent: Observation
Id: cgm-sensor-reading-mass-per-volume
Title: "CGM Sensor Reading (Mass)"
Description: "A continuous glucose monitoring (CGM) sensor reading represented in mass units."
* insert ObservationBase
* insert GlucoseMassPerVolume
* obeys cgm-sensor-value-or-dar
* code = $LNC#99504-3
* effectiveDateTime 1..1 MS
  * ^short = "Time the measurement was taken"

Profile: CGMSensorReadingMolesPerVolume
Parent: Observation
Id: cgm-sensor-reading-moles-per-volume
Title: "CGM Sensor Reading (Molar)"
Description: "A continuous glucose monitoring (CGM) sensor reading represented in molar units."
* insert ObservationBase
* insert GlucoseMolesPerVolume
* obeys cgm-sensor-value-or-dar
* code = $LNC#105272-9
* effectiveDateTime 1..1 MS
  * ^short = "Time the measurement was taken"

RuleSet: CGMSummaryBase
* insert ObservationBase
* code
  * ^short = "Type of CGM summary observation"
* effectivePeriod 1..1 MS
  * ^short = "Reporting period for the CGM summary."
  * start 1..1 MS
    * ^short = "Start date of the reporting period (YYYY-MM-DD)"
  * end 1..1 MS
    * ^short = "End date of the reporting period (YYYY-MM-DD)"

Invariant: cgm-sensor-value-or-dar
Description: "A sensor reading must have a valueQuantity or a dataAbsentReason."
Expression: "value.exists() or dataAbsentReason.exists()"
Severity: #error
 
Profile: CGMSummaryObservation
Parent: Observation
Id: cgm-summary  
Title: "CGM Summary Observation"
Description: "An observation representing a summary of continuous glucose monitoring (CGM) data."
* insert ObservationBase
* code = CGMSummaryWithLoinc
* effectivePeriod 1..1 MS
  * ^short = "Reporting period for the CGM summary"
  * start 1..1 MS
    * ^short = "Start date of the reporting period (YYYY-MM-DD)" 
  * end 1..1 MS
    * ^short = "End date of the reporting period (YYYY-MM-DD)"
* hasMember ^slicing.discriminator.type = #value
  * ^short = "Slicing based on the typ[e] of the referenced resource"
* hasMember ^slicing.discriminator.path = "resolve().code"
  * ^short = "Path used to identify the slices"
* hasMember ^slicing.rules = #open
  * ^short = "Open slicing allowing additional slices"  
* hasMember 6..*
* hasMember contains
    meanGlucoseMassPerVolume 0..1 MS and
    meanGlucoseMolesPerVolume 0..1 MS and
    timesInRanges 1..1 MS and 
    gmi 1..1 MS and
    cv 1..1 MS and
    daysOfWear 1..1 MS and
    sensorActivePercentage 1..1 MS
  * ^short = "CGM summary observations"
* hasMember[meanGlucoseMassPerVolume] only Reference(CGMSummaryMeanGlucoseMassPerVolume)
  * ^short = "Mean Glucose (Mass) observation"
* hasMember[meanGlucoseMolesPerVolume] only Reference(CGMSummaryMeanGlucoseMolesPerVolume)
  * ^short = "Mean Glucose (Molar) observation" 
* hasMember[timesInRanges] only Reference(CGMSummaryTimesInRanges)
  * ^short = "Times in Ranges observation"
* hasMember[gmi] only Reference(CGMSummaryGMI)
  * ^short = "Glucose Management Indicator (GMI) observation"
* hasMember[cv] only Reference(CGMSummaryCoefficientOfVariation)
  * ^short = "Coefficient of Variation (CV) observation"
* hasMember[daysOfWear] only Reference(CGMSummaryDaysOfWear)
  * ^short = "Days of Wear observation"
* hasMember[sensorActivePercentage] only Reference(CGMSummarySensorActivePercentage)
  * ^short = "Sensor Active Percentage observation"

Profile: CGMSummaryPDF
Parent: DiagnosticReport 
Id: cgm-summary-pdf
Title: "CGM Summary PDF Report"
Description: "A PDF report containing a summary of continuous glucose monitoring (CGM) data."
* insert DiagnosticReportBase
* subject 1..1 MS
  * ^short = "Patient for the report" 
* code = CGMSummaryCodesTemporary#cgm-summary
  * ^short = "Code for CGM Summary report"
* effectivePeriod 1..1 MS
  * start 1..1 MS
    * ^short = "Start date of the reporting period (YYYY-MM-DD)"
  * end 1..1 MS
    * ^short = "End date of the reporting period (YYYY-MM-DD)"
* presentedForm
  * ^slicing.discriminator.type = #value
  * ^slicing.discriminator.path = "contentType"
  * ^slicing.rules = #open
* presentedForm contains
    cgmSummaryPDF 1..* MS
  * ^short = "CGM Summary PDF report"
* presentedForm[cgmSummaryPDF]
  * contentType = #application/pdf
    * ^short = "PDF content type"
  * data 1..1 MS
    * ^short = "Base64-encoded PDF report data"
* result ^slicing.discriminator.type = #value
  * ^short = "Slicing based on the pattern of the component.code"
* result ^slicing.discriminator.path = "resolve().code"
  * ^short = "Path used to identify the slices"
* result ^slicing.rules = #open
  * ^short = "Open slicing allowing additional slices"
* result contains
    cgmSummary 0..* MS
  * ^short = "CGM Summary observation"
* result[cgmSummary] only Reference(CGMSummaryObservation)
  * ^short = "CGM Summary observation"

Profile: CGMSummaryTimesInRanges
Parent: Observation
Id: cgm-summary-times-in-ranges
Title: "CGM Times in Ranges"
Description: "An observation representing the times in various ranges from a continuous glucose monitoring (CGM) summary. Value: Percent of time, with at least two decimal places of precision."
* insert CGMSummaryBase
* code = TimesInRangesLoinc
  * ^short = "Code for Times in Ranges observation (LOINC: 106793-3)"
* component
  * ^slicing.discriminator.type = #value
  * ^slicing.discriminator.path = "code"
  * ^slicing.rules = #open
* component contains
    timeInVeryLow 1..1 MS and
    timeInLow 1..1 MS and 
    timeInTarget 1..1 MS and
    timeInHigh 1..1 MS and
    timeInVeryHigh 1..1 MS
  * ^short = "Components representing times in different ranges"
* component[timeInVeryLow]
  * code = TimeInVeryLowWithLoinc
  * insert QuantityPercent
* component[timeInLow]  
  * code = TimeInLowWithLoinc
  * insert QuantityPercent
* component[timeInTarget]
  * code = TimeInTargetWithLoinc
  * insert QuantityPercent
* component[timeInHigh]
  * code = TimeInHighWithLoinc
  * insert QuantityPercent
* component[timeInVeryHigh]
  * code = TimeInVeryHighWithLoinc
  * insert QuantityPercent
 

Profile: CGMSummaryMeanGlucoseMassPerVolume
Parent: Observation
Id: cgm-summary-mean-glucose-mass-per-volume
Title: "Mean Glucose (Mass)"
Description: "The mean glucose value from a continuous glucose monitoring (CGM) summary, represented in mass units."
* insert CGMSummaryBase
* code = MeanGlucoseMassPerVolumeWithLoinc
  * ^short = "Code for Mean Glucose observation"
* insert GlucoseMassPerVolume


Profile: CGMSummaryMeanGlucoseMolesPerVolume
Parent: Observation
Id: cgm-summary-mean-glucose-moles-per-volume
Title: "Mean Glucose (Molar)"
Description: "The mean glucose value from a continuous glucose monitoring (CGM) summary, represented in molar units."
* insert CGMSummaryBase
* code = MeanGlucoseMolar
  * ^short = "Code for Mean Glucose observation"
* insert GlucoseMolesPerVolume

RuleSet: QuantityPercent
* value[x] only Quantity
* valueQuantity 1..1 MS
* valueQuantity = '%' "%"
  * ^short = "Value as a percentage"

Profile: CGMSummaryGMI
Parent: Observation
Id: cgm-summary-gmi
Title: "Glucose Management Indicator (GMI)"
Description: "The Glucose Management Indicator (GMI) value from a continuous glucose monitoring (CGM) summary."
* insert CGMSummaryBase
* code = GMIWithLoinc
  * ^short = "Code for Glucose Management Indicator (GMI) observation"
* insert QuantityPercent

Profile: CGMSummaryCoefficientOfVariation
Parent: Observation
Id: cgm-summary-coefficient-of-variation
Title: "Coefficient of Variation (CV)"
Description: "The Coefficient of Variation (CV) value from a continuous glucose monitoring (CGM) summary."
* insert CGMSummaryBase
* code = CVWithLoinc
  * ^short = "Code for Coefficient of Variation (CV) observation"
* insert QuantityPercent

Profile: CGMSummaryDaysOfWear
Parent: Observation
Id: cgm-summary-days-of-wear
Title: "Days of Wear"
Description: "The number of days the continuous glucose monitoring (CGM) device was worn during the reporting period."
* insert CGMSummaryBase
* code = DaysOfWearWithLoinc
  * ^short = "Code for Days of Wear observation"
* valueQuantity 1..1 MS
* valueQuantity = 'd' "days"
  * ^short = "Number of days the CGM device was worn"

Profile: CGMSummarySensorActivePercentage
Parent: Observation
Id: cgm-summary-sensor-active-percentage
Title: "Sensor Active Percentage"
Description: "The percentage of time the continuous glucose monitoring (CGM) sensor was active during the reporting period."
* insert CGMSummaryBase
* code = SensorActivePercentageWithLoinc
  * ^short = "Code for Sensor Active Percentage observation"
* insert QuantityPercent

Profile: CGMDevice
Parent: Device
Id: cgm-device
Title: "CGM Device"
Description: "A continuous glucose monitoring (CGM) sensor device. This corresponds to the CGM sensor, not a reader or app used to capture or transmit the data."
* deviceName 1..* MS
  * ^short = "Name of the CGM device (including manufacturer and model)"
* deviceName ^slicing.rules = #open
* deviceName ^slicing.discriminator.type = #value
* deviceName ^slicing.discriminator.path = "type"
* deviceName contains
    cgmDeviceName 1..1 MS
* deviceName[cgmDeviceName].name 1..1 MS
  * ^short = "Device name including manufacturer and model"
* deviceName[cgmDeviceName].type = #user-friendly-name
  * ^short = "User-friendly name"
* identifier 1..* MS
  * ^short = "Identifier for the CGM sensor device"
* serialNumber 0..1 MS
  * ^short = "Serial number of the CGM sensor device"

CodeSystem: CGMCodes
Id: cgm
Title: "Codes for CGM"
Description: "Codes to identify content associated with this IG"
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #cgm-data-submission-standing-order "CGM Submission Standing Order" "A ServiceRequest code that identifies a \"standing order\" for CGM data."
* #cgm-data-submission-one-time-order "CGM Submission One-Time Order" "A ServiceRequest code that identifies a \"one-time order\" for CGM data."

CodeSystem: CGMSummaryCodesTemporary
Id: cgm-summary-codes-temporary
Title: "CGM Summary Code System"
Description: "Temporary code system for CGM summary observations. NOTE: Most codes have been retired and replaced by LOINC. This CodeSystem is maintained for the single remaining temporary concept."
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #cgm-summary "CGM Summary Report"

Instance: CGMSummaryToLoinc
InstanceOf: ConceptMap
Usage: #definition
Title: "Mapping from CGM Temporary Codes to LOINC"
Description: "Mapping concepts from the CGM Summary code system to LOINC codes. NOTE: Most temporary codes have been retired; this map reflects the single remaining temporary concept."
* name  = "CGMSummaryToLoinc"
* experimental = false
* status = #active
* group[+].source = Canonical(CGMSummaryCodesTemporary)
* group[=].target = $LNC
* group[=].element[+]
  * code = #cgm-summary
  * target[+].code = #104643-2
  * target[=].equivalence = #equivalent
  * target[=].comment = "Expected publication date February 2025"

Instance: CGMSummaryWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = CGMSummaryCodesTemporary#cgm-summary
// * coding[+] =  $LNC#104643-2

Instance: TimesInRangesLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#106793-3 // "Continuous glucose monitoring time in ranges panel"

Instance: MeanGlucoseMassPerVolumeWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#97507-8 // "Glucose [Mass/volume] in Serum or Plasma by Continuous glucose monitoring"

Instance: GMIWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#97506-0 // "Glucose management indicator by Continuous glucose monitoring"

Instance: TimeInVeryLowWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104642-4 // "Continuous glucose monitoring time below glucose threshold level 1"

Instance: TimeInLowWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104641-6 // "Continuous glucose monitoring time below glucose threshold level 2"

Instance: TimeInTargetWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#97510-2 // "Continuous glucose monitoring time in range"

Instance: MeanGlucoseMolar
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#105273-7 // "Glucose [Moles/volume] in Capillary blood by Continuous glucose monitoring"

Instance: TimeInHighWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104640-8 // "Continuous glucose monitoring time above glucose threshold level 1"

Instance: TimeInVeryHighWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104639-0 // "Continuous glucose monitoring time above glucose threshold level 2"

Instance: CVWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104638-2 // "Coefficient of variation of glucose by Continuous glucose monitoring"

Instance: DaysOfWearWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104636-6 // "Continuous glucose monitoring duration of use"

Instance: SensorActivePercentageWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = $LNC#104637-4 // "Continuous glucose monitoring sensor wear time active"


Profile: CGMDataSubmissionBundle
Parent: Bundle
Id: cgm-data-submission-bundle
Title: "CGM Data Submission Bundle"
Description: """
Once a Data Submitter is connected to the EHR, it can POST CGM data as a [`transaction` Bundle](https://hl7.org/fhir/R4/http.html#transaction)  to `[base]/$submit-cgm-bundle`.

The Bundle `entry` array includes any combination of 

* CGM Summary PDF Reports ([Profile](StructureDefinition-cgm-summary-pdf.html#profile), [Example](DiagnosticReport-cgmSummaryPDFExample.json.html#root))
* CGM Summary Observation ([Profile](StructureDefinition-cgm-summary.html#profile), [Example](Observation-cgmSummaryExample.json.html#root))
  * Mean Glucose (Mass per Volume) ([Profile](StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html#profile), [Example](Observation-cgmSummaryMeanGlucoseMassPerVolumeExample.json.html#root))
  * Mean Glucose (Moles per Volume) ([Profile](StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html#profile), [Example](Observation-cgmSummaryMeanGlucoseMolesPerVolumeExample.json.html#root))
  * Times in Ranges ([Profile](StructureDefinition-cgm-summary-times-in-ranges.html#profile), [Example](Observation-cgmSummaryTimesInRangesExample.json.html#root))
  * Glucose Management Indicator ([Profile](StructureDefinition-cgm-summary-gmi.html#profile), [Example](Observation-cgmSummaryGMIExample.json.html#root))
  * Coefficient of Variation ([Profile](StructureDefinition-cgm-summary-coefficient-of-variation.html#profile), [Example](Observation-cgmSummaryCoefficientOfVariationExample.json.html#root))
  * Sensor Days of Wear ([Profile](StructureDefinition-cgm-summary-days-of-wear.html#profile), [Example](Observation-cgmSummaryDaysOfWearExample.json.html#root))
  * Sensor Active Percentage ([Profile](StructureDefinition-cgm-summary-sensor-active-percentage.html#profile), [Example](Observation-cgmSummarySensorActivePercentageExample.json.html#root))
* CGM Devices ([Profile](StructureDefinition-cgm-device.html#profile), [Example](Device-cgmDeviceExample.json.html#root))
* CGM Sensor Readings (Mass per Volume) ([Profile](StructureDefinition-cgm-sensor-reading-mass-per-volume.html#profile), [Example](Observation-cgmSensorReadingMassPerVolumeExample.json.html#root))
* CGM Sensor Readings (Moles per Volume) ([Profile](StructureDefinition-cgm-sensor-reading-moles-per-volume.html#profile), [Example](Observation-cgmSensorReadingMolesPerVolumeExample.json.html#root))
"""
* type = #transaction
* timestamp 1..1 MS
  * ^short = "Instant the bundle was created"
* entry
  * ^slicing.discriminator[+].type = #type
  * ^slicing.discriminator[=].path = "resource"
  * ^slicing.discriminator[+].type = #value
  * ^slicing.discriminator[=].path = "resource.ofType(Observation).code"
  * ^slicing.rules = #open
* entry 1..* MS
* entry contains
    patient 0..1 MS and
    observation 0..* MS and
    diagnosticReport 0..* MS and
    device 0..* MS
* entry[patient].resource only Patient
  * ^short = "Patient entry"
* entry[device].resource only CGMDevice
  * ^short = "CGM device entry must conform to CGMDevice profile"
* entry[diagnosticReport].resource only CGMSummaryPDF
  * ^short = "CGM summary PDF entry must conform to CGMSummaryPDF profile"
* entry[observation] contains
    cgmSummary 0..* MS and
    cgmSummaryMeanGlucoseMassPerVolume 0..* MS  and
    cgmSummaryMeanGlucoseMolesPerVolume 0..* MS and
    cgmSummaryTimesInRanges 0..* MS and
    cgmSummaryGMI 0..* MS and
    cgmSummaryCoefficientOfVariation 0..* MS and
    cgmSummaryDaysOfWear 0..* MS and
    cgmSummarySensorActivePercentage 0..* MS and
    cgmSensorReadingMassPerVolume 0..* MS and
    cgmSensorReadingMolesPerVolume 0..* MS
* entry[observation][cgmSummary].resource only CGMSummaryObservation
* entry[observation][cgmSummaryMeanGlucoseMassPerVolume].resource only CGMSummaryMeanGlucoseMassPerVolume
* entry[observation][cgmSummaryMeanGlucoseMolesPerVolume].resource only CGMSummaryMeanGlucoseMolesPerVolume
* entry[observation][cgmSummaryTimesInRanges].resource only CGMSummaryTimesInRanges
* entry[observation][cgmSummaryGMI].resource only CGMSummaryGMI
* entry[observation][cgmSummaryCoefficientOfVariation].resource only CGMSummaryCoefficientOfVariation
* entry[observation][cgmSummaryDaysOfWear].resource only CGMSummaryDaysOfWear
* entry[observation][cgmSummarySensorActivePercentage].resource only CGMSummarySensorActivePercentage
* entry[observation][cgmSensorReadingMassPerVolume].resource only CGMSensorReadingMassPerVolume
* entry[observation][cgmSensorReadingMolesPerVolume].resource only CGMSensorReadingMolesPerVolume

Profile: DataSubmissionStandingOrder
Parent: ServiceRequest
Id: data-submission-standing-order
Title: "Data Submission Standing Order"
Description: """
A base profile for standing orders that indicate data submission requirements. This profile can be used as-is for general data submissions or inherited by more specific data submission profiles.

Key aspects of this profile:
* Specifies what data should be included in each submission
* Defines how often data should be submitted
* Indicates the lookback period each submission should cover

This profile uses the DataSubmissionSchedule extension to capture detailed submission requirements.
"""
* intent = #order
  * ^short = "Intent is #order"
* code 1..1 MS
  * ^short = "Code identifying the type of data submission standing order"
  * ^definition = "A code that specifies the type of data submission this standing order represents. This should be populated with a value that clearly identifies the nature of the data being submitted."
* subject 1..1 MS
  * ^short = "Patient for the submission order"
  * ^definition = "Reference to the patient for whom this data submission standing order applies. This is required to ensure that submitted data is associated with the correct patient."
* extension contains 
    DataSubmissionSchedule named dataSubmissionSchedule 0..*
  * ^definition = "Contains one or more DataSubmissionSchedule extensions, each defining a specific schedule and type of data to be submitted."
  * ^short = "DataSubmissionSchedule extensions"
* extension[dataSubmissionSchedule]
  * ^short = "Schedules for data submission"


Profile: CGMDataSubmissionStandingOrder
Parent: DataSubmissionStandingOrder
Id: cgm-data-submission-standing-order
Title: "CGM Data Submission Standing Order"
Description: """
The Data Receiver can expose a standing order indicating:

* What data a Data Submitter should include in each CGM Data Submission Bundle
* How often a Data Submitter should submit CGM data
* What lookback period should each submission cover

**Guiding Data Submission**

This standing order is modeled as a FHIR [`ServiceRequest`](https://hl7.org/fhir/R4/servicerequest.html) resource, which 
Data Submitters can query to guide their future submissions. The standing order specifies the patient, the type of data to be submitted, and the frequency of submission.

**DataSubmissionSchedule**

The [`DataSubmissionSchedule`](StructureDefinition-data-submission-schedule.html) extension contains:

- `submissionPeriod`: Quantity, with units bound to the [UnitsOfTime](http://hl7.org/fhir/ValueSet/units-of-time) value set (allowing `s`, `min`, `h`, `d`, `wk`, `mo`, `a`). This indicates how often the data should be submitted (e.g., every 2 weeks, every month).
- `submissionDataProfile` (1..*): `canonical` reference to FHIR profiles that represent the types of data to be submitted according to the specified schedule.
- `lookbackPeriod` (optional): Quantity, with units bound to the [UnitsOfTime](http://hl7.org/fhir/ValueSet/units-of-time) value set (allowing `s`, `min`, `h`, `d`, `wk`, `mo`, `a`). This indicates the period of time the data submission should cover (e.g., past 30 days, past 3 months).

While the value set supports granular units like seconds, minutes, and hours, common practice for CGM data submission schedules typically involves longer durations such as days, weeks, or months.
Multiple `DataSubmissionSchedule` extensions can be included in a single `DataSubmissionRequest` resource if the Data Recipient prefers a different schedule for different data types.

It's important to note that a patient or provider can also **manually trigger** a submission within an app. For example, if there is an upcoming appointment, the provider can click a button to fetch the most up-to-date results. Out-of-band communication between the app developer and the clinical provider system can also be used to establish preferred submission schedules.

"""
* intent = #order
  * ^short = "Intent for CGM is #order"
* code = CGMCodes#cgm-data-submission-standing-order
  * ^short = "Code for CGM submission standing order"
* subject 1..1
  * ^short = "Patient for the CGM submission order"
* extension[dataSubmissionSchedule]
  * ^short = "Schedules for CGM data submission"

Profile: DataSubmissionOneTimeOrder
Parent: ServiceRequest
Id: data-submission-one-time-order
Title: "Data Submission One-Time Order"
Description: """
A base profile for one-time orders that specify an absolute time period for data collection. This profile can be used as-is for general one-time data submissions or inherited by more specific data submission profiles.

Key aspects of this profile:
* Specifies what data should be included in the submission
* Defines an absolute time period (using FHIR Period data type) for data collection
* Intended for one-time, on-demand data requests

This profile uses the DataSubmissionOneTimeSpec extension to capture detailed submission requirements.
"""
* intent = #order
  * ^short = "Intent is #order"
* code 1..1 MS
  * ^short = "Code identifying the type of data submission one-time order"
  * ^definition = "A code that specifies the type of data submission this one-time order represents. This should be populated with a value that clearly identifies the nature of the data being submitted."
* subject 1..1 MS
  * ^short = "Patient for the one-time submission order"
  * ^definition = "Reference to the patient for whom this data submission one-time order applies. This is required to ensure that submitted data is associated with the correct patient."
* extension contains 
    DataSubmissionOneTimeSpec named dataSubmissionOneTimeSpec 1..1 MS
  * ^definition = "Contains a DataSubmissionOneTimeSpec extension defining the specific time period and type of data to be submitted."
  * ^short = "DataSubmissionOneTimeSpec extension"
* extension[dataSubmissionOneTimeSpec]
  * ^short = "One-time specification for data submission"


Profile: CGMDataSubmissionOneTimeOrder
Parent: DataSubmissionOneTimeOrder
Id: cgm-data-submission-one-time-order
Title: "CGM Data Submission One-Time Order"
Description: """
A one-time order for CGM data submission that specifies an absolute time period for data collection. This profile is used to request CGM data for a specific time range, typically for on-demand data requests rather than ongoing scheduled submissions.

Key aspects of this profile:
* Specifies what data should be included in the submission
* Defines an absolute time period (using FHIR Period data type) for data collection
* Intended for one-time, on-demand data requests

**DataSubmissionOneTimeSpec Extension**

The [`DataSubmissionOneTimeSpec`](StructureDefinition-data-submission-one-time-spec.html) extension contains:

- `timePeriod`: A FHIR Period data type specifying the absolute start and end dates/times for data submission
- `submissionDataProfile` (1..*): `canonical` reference to FHIR profiles that represent the types of data to be submitted

**Data Chunking for Large Time Periods**

While one-time orders can specify any time period (including a patient's entire history), it's usually better to break large requests into meaningful chunks. Chunking makes data size manageable and summary statistics more relevant. Receivers can control chunking by sending individual requests for yearly or monthly periods where the analysis period is more meaningful.

The mechanism for transmitting one-time orders from EHR to CGM Data Submitter is left out-of-band (OOB) in this version of the specification. Future versions may provide an in-band option based on implementation experience.
"""
* intent = #order
  * ^short = "Intent is #order"
* code = CGMCodes#cgm-data-submission-one-time-order
  * ^short = "Code for CGM one-time submission order"
* subject 1..1 MS
  * ^short = "Patient for the one-time CGM submission order"
* extension contains 
    DataSubmissionOneTimeSpec named dataSubmissionOneTimeSpec 1..1 MS
  * ^definition = "Contains a DataSubmissionOneTimeSpec extension defining the specific time period and type of data to be submitted."
  * ^short = "DataSubmissionOneTimeSpec extension"
* extension[dataSubmissionOneTimeSpec]
  * ^short = "One-time specification for CGM data submission"

Extension: DataSubmissionOneTimeSpec
Id: data-submission-one-time-spec
Title: "Data Submission One-Time Specification"
Description: "Defines a one-time specification for data submission with an absolute time period"
Context: ServiceRequest
* extension contains
    timePeriod 1..1 MS and
    submissionDataProfile 1..*  MS
  * ^short = "One-time submission request"
* extension[timePeriod].value[x] only Period
  * ^short = "Absolute time period for data submission (start and end dates)"
* extension[timePeriod].valuePeriod 1..1 MS
  * ^short = "Time period with start and end dates"
* extension[timePeriod].valuePeriod.start 1..1 MS
  * ^short = "Start date/time for data submission"
* extension[timePeriod].valuePeriod.end 1..1 MS
  * ^short = "End date/time for data submission"
* extension[submissionDataProfile].value[x] only canonical
* extension[submissionDataProfile].valueCanonical 1..1 MS
  * ^short = "Data profile for submission"

Extension: DataSubmissionSchedule
Id: data-submission-schedule
Title: "Data Submission Schedule"
Description: "Schedule and type of data to be submitted"
Context: ServiceRequest
* extension contains
    submissionPeriod 1..1 MS and
    lookbackPeriod 0..1 MS and
    submissionDataProfile 1..*  MS
  * ^short = "Submission schedule"
* extension[submissionPeriod].value[x] only Quantity
  * ^short = "How often the data should be submitted."
* extension[submissionPeriod].valueQuantity from http://hl7.org/fhir/ValueSet/units-of-time (required)
* extension[lookbackPeriod].value[x] only Quantity
* extension[lookbackPeriod].valueQuantity from http://hl7.org/fhir/ValueSet/units-of-time (required)
  * ^short = "How far back the data submission should cover."
* extension[submissionDataProfile].value[x] only canonical
* extension[submissionDataProfile].valueCanonical 1..1 MS
  * ^short = "Data profile for submission"

Instance: cgm-data-receiver
InstanceOf: CapabilityStatement
Usage: #definition
Title: "CGM Data Receiver Capability Statement"
Description: """
This capability statement describes the requirements for systems receiving CGM data via the `$submit-cgm-bundle` operation.

Any CGM Data Receiver SHALL populate its `/metadata` response to ensure that `CapabilityStatement.instantiates` includes `"http://hl7.org/fhir/uv/cgm/CapabilityStatement/cgm-data-receiver"`.
"""
* status = #active
* date = 2024-05-09
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* rest[+]
  * mode = #server
  * operation[+]
    * name = "submit-cgm-bundle"
    * definition = Canonical(submit-cgm-bundle)
  * resource[+]
    * type = #ServiceRequest
    * supportedProfile[+] = Canonical(cgm-data-submission-standing-order)
    * interaction[+].code = #read
    * interaction[+].code = #search-type
    * searchParam[+]
      * name = "patient"
      * type = #reference
    * searchParam[+]
      * name = "code" 
      * type = #token
  * resource[+]
    * type = #DiagnosticReport
    * supportedProfile[+] = Canonical(CGMSummaryPDF)
    * interaction[+].code = #create
    * interaction[+].code = #update
  * resource[+]
    * type = #Device
    * supportedProfile[+] = Canonical(CGMDevice)
    * interaction[+].code = #create
    * interaction[+].code = #update
  * resource[+]
    * type = #Observation
    * supportedProfile[+] = Canonical(CGMSummaryObservation)
    * supportedProfile[+] = Canonical(CGMSummaryMeanGlucoseMassPerVolume)
    * supportedProfile[+] = Canonical(CGMSummaryMeanGlucoseMolesPerVolume)
    * supportedProfile[+] = Canonical(CGMSummaryTimesInRanges)
    * supportedProfile[+] = Canonical(CGMSummaryGMI)
    * supportedProfile[+] = Canonical(CGMSummaryCoefficientOfVariation)
    * supportedProfile[+] = Canonical(CGMSummaryDaysOfWear)
    * supportedProfile[+] = Canonical(CGMSummarySensorActivePercentage)
    * supportedProfile[+] = Canonical(CGMSensorReadingMassPerVolume)
    * supportedProfile[+] = Canonical(CGMSensorReadingMolesPerVolume)
    * interaction[+].code = #create
    * interaction[+].code = #update
    * searchParam[+]
      * name = "patient"
      * type = #reference
    * searchParam[+]
      * name = "category"
      * type = #token
    * searchParam[+]
      * name = "code"
      * type = #token

Instance: submit-cgm-bundle
InstanceOf: OperationDefinition
Usage: #definition
Title: "Submit CGM Bundle Operation"
Description: """
This operation is used to submit CGM data. The input is a Bundle of type 'transaction' containing CGM data (summary reports, sensor readings, etc.) 
and the output is a Bundle of type 'transaction-response' containing processing results for each submitted resource, or an OperationOutcome resource for overall failures.

The response Bundle will:
- Maintain the same order as the submission Bundle
- Include status and location information for each successfully processed entry
- Include error details for any entries that could not be processed

Servers SHOULD support conditional create requests and persist client-supplied identifiers. Servers SHALL document in their developer documentation:
- Which search parameters can be used in conditional create requests  
- How client-supplied identifiers are handled
- Any deduplication strategies employed
"""

* id = "submit-cgm-bundle"
* name = "SubmitCGMBundle"
* title = "Submit CGM Bundle"
* status = #active
* kind = #operation
* code = #submit-cgm-bundle
* resource = #Bundle
* system = false
* type = true
* instance = false
* inputProfile = Canonical(CGMDataSubmissionBundle)
* parameter[0]
  * name = #resource
  * use = #in
  * min = 1
  * max = "1"
  * documentation = "A Bundle of type 'transaction' containing CGM data including summary reports, sensor readings, and related resources."
  * type = #Bundle
* parameter[1]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * documentation = """
    A Bundle of type 'transaction-response' containing processing results for each submitted resource. Each entry in the response Bundle corresponds 
    to an entry in the submission Bundle and includes:
    - HTTP status code indicating success/failure
    - Location header for successful creations
    - OperationOutcome for any entry-specific errors
    
    If the entire operation fails, a single OperationOutcome resource is returned instead.
    """
  * type = #Bundle
