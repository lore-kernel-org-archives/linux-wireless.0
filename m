Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64099 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYHMWss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 18:48:48 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: wimax@linuxwimax.org
Subject: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050 v1.2.5
Date: Wed, 13 Aug 2008 15:48:32 -0700
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808131548.32207.inaky@linux.intel.com> (sfid-20080814_004851_907952_6E16132B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All


Intel would like to announce the 1.2.5 release of the Linux WiMAX common
stack and drivers for its WiMAX devices (eg: Intel(r) WiMAX/WiFi Link 5050).

You can find the code and additional information at http://linuxwimax.org.

This is a maintenance release; the changes from release 1.2 to 1.2.5 are:

* WiMAX network service:*

Miscellaneous fixes:

- Unable to connect using eap-tls authentication (workaround fix with
  host side tls)

- SW RF state is not restored across wimax service restarts.

- Repeat connect/disconnect sequence causes the device and wimax
  service to reset.

- Switching HW radio on/off crashes the wimax service.

- CINR/RSSI values are not reported correctly.

- NDnSAgentConfig_forDriver.xml sometimes get corrupted during wimax
  service shutdown.

- Disconnecting from auto-connect mode does not change mode to manual.

- wimaxcu crashes when launched without wimax service 

- Not all information or some information is incorrectly reported on
  querying device info.

- Device state cotinues to be reported as connected after losing
  connection for extended period.


* WiMAX kernel stack and drivers:

Miscellaneous fixes

- fix memory corruption caused by race condition on freed skb

- use skb_end_pointer() instead of skb->end so we work properly on 64 bits

-- 
Inaky
