Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58599 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0KSTuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 14:50:21 -0500
From: Bing Zhao <bzhao@marvell.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] linux-firmware: use single license file for Marvell firmwares
Date: Fri, 19 Nov 2010 11:36:16 -0800
Message-Id: <1290195377-17805-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Libertas and mwl8k firmware images are under the same license.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 LICENCE.libertas                 |   19 -------------------
 LICENCE.mwl8k => LICENSE.Marvell |    0
 WHENCE                           |    4 ++--
 3 files changed, 2 insertions(+), 21 deletions(-)
 delete mode 100644 LICENCE.libertas
 rename LICENCE.mwl8k => LICENSE.Marvell (100%)

diff --git a/LICENCE.libertas b/LICENCE.libertas
deleted file mode 100644
index 1fd8766..0000000
--- a/LICENCE.libertas
+++ /dev/null
@@ -1,19 +0,0 @@
-FIRMWARE LICENSE TERMS
-
-
-Copyright (c) Marvell International Ltd.
-
-All rights reserved.
-
-Redistribution. Redistribution and use in binary form, without modification, are permitted provided that the following conditions are met:
-
-* Redistributions must reproduce the above copyright notice and the following disclaimer in the documentation and/or other materials provided with the distribution.
-
-* Neither the name of Marvell International Ltd. nor the names of its suppliers may be used to endorse or promote products derived from this software without specific prior written permission.
-
-* No reverse engineering, decompilation, or disassembly of this software is permitted.
-
-Limited patent license. Marvell International Ltd. grants a world-wide, royalty-free, non-exclusive license under patents it now or hereafter owns or controls to make, have made, use, import, offer to sell and sell ("Utilize") this software, but solely to the extent that any such patent is necessary to Utilize the software alone, or in combination with an operating system licensed under an approved Open Source license as listed by the Open Source Initiative at http://opensource.org/licenses. The patent license shall not apply to any other combinations which include this software. No hardware per se is licensed hereunder.
-
-DISCLAIMER. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-
diff --git a/LICENCE.mwl8k b/LICENSE.Marvell
similarity index 100%
rename from LICENCE.mwl8k
rename to LICENSE.Marvell
diff --git a/WHENCE b/WHENCE
index 907fe68..41d55a5 100644
--- a/WHENCE
+++ b/WHENCE
@@ -629,7 +629,7 @@ File: libertas/usb8388_v5.bin
 File: libertas/usb8388_v9.bin
 File: libertas/usb8682.bin
 
-Licence: Redistributable. See LICENCE.libertas for details.  Extracted from
+Licence: Redistributable. See LICENSE.Marvell for details.  Extracted from
 Linux driver tarballs downloaded from Marvell's "Extranet" with permission.
 
 --------------------------------------------------------------------------
@@ -639,7 +639,7 @@ Driver: mwl8k - Marvell Libertas softmac-type 802.11b/g cards
 File: mwl8k/fmimage_8687.fw
 File: mwl8k/helper_8687.fw
 
-Licence: Redistributable. See LICENCE.mwl8k for details.  Downloaded from
+Licence: Redistributable. See LICENSE.Marvell for details.  Downloaded from
 Marvell's "Extranet" with permission.
 
 --------------------------------------------------------------------------
-- 
1.7.0.2

