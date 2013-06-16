//
//  _ARLab_3d.h
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#ifdef EDR_ADVANCED

#define EDR_ADV_120901 0.10
#define EDR_ADV_120902 0.11
#define UNKNOWN
#define ARLAB_AVAILABLE(__ARLab_version)
#define ARLAB_AVAILABLE_BUT_DEPRECATED(__ARLab_version)
#define ARLAB_DEPRECATED(__ARLab_version_Intro, __ARLab_version_Dep)
#define ARLAB_NOT_AVAILABLE_UNTIL(__ARLab_expected_version)

#elif EAD_LITE

#define EDR_LITE_120901 0.10
#define EDR_LITE_120901 0.11
#define UNKNOWN
#define ARLAB_AVAILABLE(__ARLab_version)
#define ARLAB_AVAILABLE_BUT_DEPRECATED(__ARLab_version)
#define ARLAB_DEPRECATED(__ARLab_version_Intro, __ARLab_version_Dep)
#define ARLAB_NOT_AVAILABLE_UNTIL(__ARLab_expected_version)

#endif