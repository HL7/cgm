Instance: patientExample
InstanceOf: Patient
Title: "Example Patient" 
Usage: #example
* identifier[0].use = #official
* identifier[0].system = "http://example.org"
* identifier[0].value = "ee8d4ac0-545c-4501-8d7e-646bfbda1db5"
* name.family = "Peters"
* name.given[0] = "Amy"
* gender = #female
* birthDate = "1964-06-20"

Instance: cgmSensorReadingMassPerVolumeExample
InstanceOf: CGMSensorReadingMassPerVolume
Title: "CGM Sensor Reading (Mass) Example"
Usage: #example
* status = #final 
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectiveDateTime = "2024-05-02T10:15:00Z"
* valueQuantity.value = 120 

Instance: cgmSensorReadingMolesPerVolumeExample
InstanceOf: CGMSensorReadingMolesPerVolume
Title: "CGM Sensor Reading (Molar) Example" 
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectiveDateTime = "2024-05-02T10:30:00Z"
* valueQuantity.value = 6.7

Instance: cgmSummaryMeanGlucoseMassPerVolumeExample
InstanceOf: CGMSummaryMeanGlucoseMassPerVolume
Title: "Mean Glucose (Mass) Example"
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31"
* valueQuantity.value = 145


Instance: cgmSummaryMeanGlucoseMolesPerVolumeExample
InstanceOf: CGMSummaryMeanGlucoseMolesPerVolume
Title: "Mean Glucose (Molar) Example"
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01" 
* effectivePeriod.end = "2024-05-31"
* valueQuantity.value = 8.1

Instance: cgmSummaryTimesInRangesExample
InstanceOf: CGMSummaryTimesInRanges
Title: "CGM Summary Times in Ranges Example" 
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31"  
* component[timeInVeryLow].valueQuantity.value = 3 
* component[timeInLow].valueQuantity.value = 8
* component[timeInTarget].valueQuantity.value = 65
* component[timeInHigh].valueQuantity.value = 20
* component[timeInVeryHigh].valueQuantity.value = 4

Instance: cgmSummaryGMIExample
InstanceOf: CGMSummaryGMI  
Title: "GMI Example"
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31" 
* valueQuantity.value = 6.8

Instance: cgmSummaryCoefficientOfVariationExample
InstanceOf: CGMSummaryCoefficientOfVariation
Title: "Coefficient of Variation Example"
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31"
* valueQuantity.value = 34


Instance: cgmSummaryDaysOfWearExample
InstanceOf: CGMSummaryDaysOfWear
Title: "Days of Wear Example"
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31" 
* valueQuantity.value = 28

Instance: cgmSummarySensorActivePercentageExample  
InstanceOf: CGMSummarySensorActivePercentage
Title: "Sensor Active Percentage Example" 
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31"
* valueQuantity.value = 95

Instance: cgmSummaryExample
InstanceOf: CGMSummaryObservation
Title: "CGM Summary Example"
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-31"
* hasMember[meanGlucoseMassPerVolume] = Reference(cgmSummaryMeanGlucoseMassPerVolumeExample)
* hasMember[timesInRanges] = Reference(cgmSummaryTimesInRangesExample)
* hasMember[gmi] = Reference(cgmSummaryGMIExample)
* hasMember[cv] = Reference(cgmSummaryCoefficientOfVariationExample)
* hasMember[daysOfWear] = Reference(cgmSummaryDaysOfWearExample)  
* hasMember[sensorActivePercentage] = Reference(cgmSummarySensorActivePercentageExample)

Instance: cgmSummaryPDFExample
InstanceOf: CGMSummaryPDF
Title: "CGM Summary PDF Report Example"
Usage: #example
* status = #final
* issued = "2024-05-15T14:30:00Z"
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/v2-0074#LAB
* effectivePeriod.start = "2024-05-01"
* effectivePeriod.end = "2024-05-14"
* presentedForm[cgmSummaryPDF]
  * contentType = #application/pdf
  * data = "JVBERi0xLjAKJcK1wrYKCjEgMCBvYmoKPDwvVHlwZS9DYXRhbG9nL1BhZ2VzIDIgMCBSPj4KZW5kb2JqCgoyIDAgb2JqCjw8L0tpZHNbMyAwIFJdL0NvdW50IDEvVHlwZS9QYWdlcy9NZWRpYUJveFswIDAgNTk1IDc5Ml0+PgplbmRvYmoKCjMgMCBvYmoKPDwvVHlwZS9QYWdlL1BhcmVudCAyIDAgUi9Db250ZW50cyA0IDAgUi9SZXNvdXJjZXM8PD4+Pj4KZW5kb2JqCgo0IDAgb2JqCjw8L0xlbmd0aCA1OD4+CnN0cmVhbQpxCkJUCi8gOTYgVGYKMSAwIDAgMSAzNiA2ODQgVG0KKEZISVIgQ0dNISkgVGoKRVQKUQoKZW5kc3RyZWFtCmVuZG9iagoKeHJlZgowIDUKMDAwMDAwMDAwMCA2NTUzNiBmIAowMDAwMDAwMDE2IDAwMDAwIG4gCjAwMDAwMDAwNjIgMDAwMDAgbiAKMDAwMDAwMDEzNiAwMDAwMCBuIAowMDAwMDAwMjA5IDAwMDAwIG4gCgp0cmFpbGVyCjw8L1NpemUgNS9Sb290IDEgMCBSPj4Kc3RhcnR4cmVmCjMxNgolJUVPRgoK"
* result = Reference(cgmSummaryExample)

Instance: cgmDataSubmissionBundle
InstanceOf: CGMDataSubmissionBundle
Title: "CGM Data Submission Bundle Example"
Usage: #example
* type = #transaction
* timestamp = "2024-05-02T14:30:00Z" 
* entry[+].resource = cgmSummaryPDFExample
* entry[=].fullUrl = "https://example.org/DiagnosticReport/cgmSummaryPDFExample"
* entry[=].request.method = #POST
* entry[=].request.url = "DiagnosticReport"
* entry[+].resource = cgmSummaryExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummaryExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSummaryMeanGlucoseMassPerVolumeExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummaryMeanGlucoseMassPerVolumeExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSummaryTimesInRangesExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummaryTimesInRangesExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSummaryGMIExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummaryGMIExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSummaryCoefficientOfVariationExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummaryCoefficientOfVariationExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSummaryDaysOfWearExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummaryDaysOfWearExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSummarySensorActivePercentageExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSummarySensorActivePercentageExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"
* entry[+].resource = cgmSensorReadingMassPerVolumeExample
* entry[=].fullUrl = "https://example.org/Observation/cgmSensorReadingMassPerVolumeExample"
* entry[=].request.method = #POST
* entry[=].request.url = "Observation"

Instance: cgmDataSubmissionStandingOrderExample
InstanceOf: CGMDataSubmissionStandingOrder
Usage: #example
Title: "Example CGM Data Submission Standing Order"
Description: """
This example represents a standing order for continuous glucose monitoring (CGM) data submission.
It specifies an order to submit data about Patient 123 once every two weeks, with each data submission including
a summary of the CGM data and a PDF report of the CGM summary. This ensures the patient's CGM data is routinely
available for clinical review.
"""
* status = #active
* intent = #order
* code = CGMCodes#cgm-data-submission-standing-order
* subject = Reference(Patient/example)
* extension[dataSubmissionSchedule].extension[submissionPeriod].valueQuantity.value = 2
* extension[dataSubmissionSchedule].extension[submissionPeriod].valueQuantity = 'wk' "week"
* extension[dataSubmissionSchedule].extension[submissionDataProfile][0].valueCanonical = Canonical(CGMSummaryObservation)
* extension[dataSubmissionSchedule].extension[submissionDataProfile][+].valueCanonical = Canonical(CGMSummaryPDF) 

Instance: cgmDeviceExample
InstanceOf: CGMDevice
Title: "CGM Device Example"
Usage: #example
* deviceName[cgmDeviceName].name = "Acme CGM System"
* serialNumber = "ABC123"  
* identifier[0].system = "http://acme.com/devices"
* identifier[0].value = "456789"
