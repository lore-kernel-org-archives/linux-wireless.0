Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:59896 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaCNIjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 04:39:52 -0400
Subject: [PATCH 1/3] Rename LICENSE.atheros_firmware to LICENCE.old_qca
To: ben@decadent.org.uk
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org
Date: Fri, 14 Mar 2014 10:45:01 +0200
Message-ID: <20140314084501.23100.13103.stgit@x230> (sfid-20140314_093959_552626_EE842332)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for the new QCA license.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 LICENCE.atheros_firmware |   38 --------------------------------------
 LICENCE.old_qca          |   38 ++++++++++++++++++++++++++++++++++++++
 WHENCE                   |   18 +++++++++---------
 3 files changed, 47 insertions(+), 47 deletions(-)
 delete mode 100644 LICENCE.atheros_firmware
 create mode 100644 LICENCE.old_qca

diff --git a/LICENCE.atheros_firmware b/LICENCE.atheros_firmware
deleted file mode 100644
index e0ebdac..0000000
--- a/LICENCE.atheros_firmware
+++ /dev/null
@@ -1,38 +0,0 @@
-Copyright (c) 2008-2010, Atheros Communications, Inc.
-All rights reserved.
-
-Redistribution.  Redistribution and use in binary form, without
-modification, are permitted provided that the following conditions are
-met:
-
-* Redistributions must reproduce the above copyright notice and the
-  following disclaimer in the documentation and/or other materials
-  provided with the distribution.
-
-* Neither the name of Atheros Communications, Inc. nor the names of
-  its suppliers may be used to endorse or promote products derived
-  from this software without specific prior written permission.
-
-* No reverse engineering, decompilation, or disassembly of this
-  software is permitted.
-
-Limited patent license.  Atheros Communications, Inc. grants a
-world-wide, royalty-free, non-exclusive license under patents it
-now or hereafter owns or controls to make, have made, use, import,
-offer to sell and sell ("Utilize") this software, but solely to
-the extent that any such patent is necessary to Utilize the software
-in conjunction with an Atheros Chipset. The patent license shall not
-apply to any other combinations which include this software. No
-hardware per se is licensed hereunder.
-
-DISCLAIMER.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
-CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
-BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
-FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
-THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
-INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
-BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
-OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
-TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
diff --git a/LICENCE.old_qca b/LICENCE.old_qca
new file mode 100644
index 0000000..e0ebdac
--- /dev/null
+++ b/LICENCE.old_qca
@@ -0,0 +1,38 @@
+Copyright (c) 2008-2010, Atheros Communications, Inc.
+All rights reserved.
+
+Redistribution.  Redistribution and use in binary form, without
+modification, are permitted provided that the following conditions are
+met:
+
+* Redistributions must reproduce the above copyright notice and the
+  following disclaimer in the documentation and/or other materials
+  provided with the distribution.
+
+* Neither the name of Atheros Communications, Inc. nor the names of
+  its suppliers may be used to endorse or promote products derived
+  from this software without specific prior written permission.
+
+* No reverse engineering, decompilation, or disassembly of this
+  software is permitted.
+
+Limited patent license.  Atheros Communications, Inc. grants a
+world-wide, royalty-free, non-exclusive license under patents it
+now or hereafter owns or controls to make, have made, use, import,
+offer to sell and sell ("Utilize") this software, but solely to
+the extent that any such patent is necessary to Utilize the software
+in conjunction with an Atheros Chipset. The patent license shall not
+apply to any other combinations which include this software. No
+hardware per se is licensed hereunder.
+
+DISCLAIMER.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
+BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
+FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
+INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
+OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
diff --git a/WHENCE b/WHENCE
index 4bcb3b5..2054239 100644
--- a/WHENCE
+++ b/WHENCE
@@ -455,7 +455,7 @@ Driver: ar9170 - Atheros 802.11n "otus" USB
 File: ar9170-1.fw
 File: ar9170-2.fw
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -469,7 +469,7 @@ Version: 1.3
 File: htc_7010.fw
 Version: 1.3
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -1328,7 +1328,7 @@ Version: 1.0
 
 Fix EEPROM radio table issue and change PID to 3005
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -2060,7 +2060,7 @@ File: ar3k/ramps_0x01020201_40.dfu
 File: ar3k/AthrBT_0x41020000.dfu
 File: ar3k/ramps_0x41020000_40.dfu
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -2078,7 +2078,7 @@ File: ar3k/30000/ar3kbdaddr.pst
 File: ar3k/30000/PS_ASIC.pst
 File: ar3k/30000/RamPatch.txt
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -2114,7 +2114,7 @@ File: ath6k/AR6002/eeprom.bin
 File: ath6k/AR6002/athwlan.bin.z77
 File: ath6k/AR6002/data.patch.hw2_0.bin
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -2144,7 +2144,7 @@ File: ath6k/AR6003.1/hw2.1.1/data.patch.bin
 File: ath6k/AR6003.1/hw2.1.1/endpointping.bin
 File: ath6k/AR6003.1/hw2.1.1/otp.bin
 
-License: Redistributable. See LICENCE.atheros_firmware for details
+License: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -2156,7 +2156,7 @@ File: ar3k/30101coex/PS_ASIC_aclHighPri.pst
 File: ar3k/30101coex/PS_ASIC.pst
 File: ar3k/30101coex/RamPatch.txt
 
-License: Redistributable. See LICENCE.atheros_firmware for details
+License: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 
@@ -2205,7 +2205,7 @@ Driver: ar5523 -- Atheros AR5523 based USB Wifi dongles
 
 File: ar5523.bin
 
-Licence: Redistributable. See LICENCE.atheros_firmware for details
+Licence: Redistributable. See LICENCE.old_qca for details
 
 --------------------------------------------------------------------------
 

