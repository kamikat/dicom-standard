# DICOM Standard Attribute Modules

Metadata of attribute modules in DICOM standard for browser use.

Uses [JSON format][1] DICOM standard by [Innolitics][2].

## Usage

Install package:

    npm install --save dicom-standard

For browser:

```javascript
import Patient from 'dicom-standard/modules/patient';
import GeneralStudy from 'dicom-standard/modules/general-study';
import GeneralSeries from 'dicom-standard/modules/general-series';
```

For Node.js:

```javascript
const Patient = require('dicom-standard/modules/patient');
const GeneralStudy = require('dicom-standard/modules/general-study');
const GeneralSeries = require('dicom-standard/modules/general-series');
```

## License

(The MIT License)

[1]: https://github.com/innolitics/dicom-standard
[2]: https://github.com/innolitics
