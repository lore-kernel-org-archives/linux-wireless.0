Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0087.outbound.protection.outlook.com ([104.47.34.87]:10941
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932792AbcKWQqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 11:46:18 -0500
From: <igor.mitsyanko.os@quantenna.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
Date: Wed, 23 Nov 2016 19:45:47 +0300
Message-ID: <1479919547-26628-1-git-send-email-igor.mitsyanko.os@quantenna.com> (sfid-20161123_174628_255598_404C7DB2)
MIME-Version: 1.0
In-Reply-To: <87d1hmnrqj.fsf@purkki.adurom.net>
References: <87d1hmnrqj.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <imitsyanko@quantenna.com>

QSR10G is Quantenna's 8x8, 160M, 11ac WiFi card.

Signed-off-by: Kamlesh Rath <krath@quantenna.com>
Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 LICENCE.Quantenna_fmac |  74 +++++++++++++++++++++++++++++++++++++++++++++++++
 WHENCE                 |   9 ++++++
 qtn/fmac_qsr10g.img    | Bin 0 -> 9559676 bytes
 3 files changed, 83 insertions(+)
 create mode 100644 LICENCE.Quantenna_fmac
 create mode 100644 qtn/fmac_qsr10g.img

diff --git a/LICENCE.Quantenna_fmac b/LICENCE.Quantenna_fmac
new file mode 100644
index 0000000..e6f9f72
--- /dev/null
+++ b/LICENCE.Quantenna_fmac
@@ -0,0 +1,74 @@
+Copyright (c) 2016, Quantenna, Inc.
+All rights reserved.
+
+Redistribution. Reproduction and redistribution in binary form, without
+modification, for use solely in conjunction with a Quantenna, Inc. chipset, is
+permitted provided that the following conditions are met:
+
+  - Redistributions must reproduce the above copyright notice and the
+    following disclaimer in the documentation and/or other materials provided
+    with the distribution.
+
+  - Neither the name of Quantenna, Inc. nor the names of its suppliers may be
+    used to endorse or promote products derived from this Software without
+    specific prior written permission.
+
+  - No reverse engineering, decompilation, or disassembly of this Software is
+    permitted, except and solely to the extent that such a restriction is
+    impermissible pursuant to applicable law or third party license.
+
+  - Your reproduction and distribution must comply with all applicable laws,
+    including without limitation all applicable U.S., European, and other
+    export laws.
+
+Limited Patent License. Subject to your compliance with all terms of this
+license, Quantenna, Inc. (“Licensor”) grants you (“Licensee”) a limited,
+worldwide, royalty-free, non-exclusive license under the Licensed Patents to
+make, have made, use, import, offer to sell and sell the Software solely in
+conjunction with a validly purchased Quantenna, Inc. chipset. No hardware
+per se is licensed hereunder.
+
+The term “Licensed Patents” as used in this agreement means only those patents
+or patent applications owned solely and exclusively by Licensor as of the date
+of Licensor’s submission of the Software that would necessarily be infringed by
+the operation of the Software, alone, or in combination with a supported
+version of the Linux operating system. The patent license shall not apply to
+any other combinations which include the Software. The term “Licensed Patents”
+expressly excludes any patent or patent application owned by any current or
+future affiliate of Quantenna, Inc. The term “Software” as used in this
+agreement means the unmodified firmware image submitted by Licensor, under the
+terms of this license, to
+git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git.
+
+Notwithstanding anything to the contrary herein, Licensor does not grant and
+Licensee does not receive, by virtue of this agreement or the Licensor’s
+submission of any Software, any license or other rights under any patent or
+patent application owned by any current or future affiliate of Licensor or any
+other entity (other than Licensor), whether expressly, impliedly, by virtue of
+estoppel or exhaustion, or otherwise. If Licensee has a separate agreement with
+Licensor covering use of the Software, then that separate agreement shall
+control.
+
+Open Source Software. The Software may include components that are licensed
+pursuant to open source software (“Open Source Components”). Information
+regarding the Open Source Components included with the Software is available
+upon request to oslegal@quantenna.com. To the extent such Open Source
+Components are required to be licensed to you under the terms of a separate
+license (such as an open source license) then such other terms shall apply, and
+nothing herein shall be deemed or interpreted to limit any rights you may have
+under any such applicable license.
+
+DISCLAIMER. THIS SOFTWARE (INCLUDING ANY APPLICABLE OPEN SOURCE COMPONENTS) IS
+PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND  ANY EXPRESS OR
+IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFREINGEMENT ARE
+EXPRESSLY DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNERS, AUTHORS, OR
+CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
+OF SUCH DAMAGE, AND REGARDLESS OF ANY FAILURE OF ESSENTIAL PURPOSE OF ANY
+LIMITED REMEDY PROVIDED HEREIN.
+
diff --git a/WHENCE b/WHENCE
index 534c2da..78f6b73 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3347,3 +3347,12 @@ File: rockchip/dptx.bin
 Version: 2.9
 
 Licence: Redistributable. See LICENCE.rockchip for details.
+
+--------------------------------------------------------------------------
+
+Driver: qtnfmac - FullMAC driver for Quantenna QSR10G wireless card
+
+File: qtn/fmac_qsr10g.img
+
+Licence: Redistributable. See LICENCE.Quantenna_fmac for details.
+
diff --git a/qtn/fmac_qsr10g.img b/qtn/fmac_qsr10g.img
new file mode 100644
index 0000000..a65e6ec
Binary files /dev/null and b/qtn/fmac_qsr10g.img differ
-- 
2.7.4
