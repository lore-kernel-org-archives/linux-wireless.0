Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37422 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJFN72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:59:28 -0400
Received: by gxk9 with SMTP id 9so4915014gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 06:59:27 -0700 (PDT)
Message-ID: <eb3ff54b0810060659n7d93a9fcla1301fa68a8a23a5@mail.gmail.com> (sfid-20081006_155931_141580_45C56F1C)
Date: Mon, 6 Oct 2008 15:59:27 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/2] iwlwifi: fix compliation warning in iwl-scan.c when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_55867_27800426.1223301567145"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_55867_27800426.1223301567145
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
we get this compilation warning:
wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-scan.c:92: warning:
'iwl_escape_essid' defined but not used

This patch (against wireless-next-2.6 tree) fixes it.


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_55867_27800426.1223301567145
Content-Type: text/plain; name=patch2.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flz65w3o0
Content-Disposition: attachment; filename=patch2.txt

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXNjYW4uYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXNjYW4uYwppbmRleCBiZjg1NWMzLi4zZTVm
ZDBlIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1zY2FuLmMK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtc2Nhbi5jCkBAIC02OSw3ICs2
OSw3IEBAIHN0YXRpYyBpbnQgc2Nhbl90eF9hbnRbM10gPSB7CiB9OwogCiAKLQorI2lmZGVmIENP
TkZJR19JV0xXSUZJX0RFQlVHCiBzdGF0aWMgaW50IGl3bF9pc19lbXB0eV9lc3NpZChjb25zdCBj
aGFyICplc3NpZCwgaW50IGVzc2lkX2xlbikKIHsKIAkvKiBTaW5nbGUgd2hpdGUgc3BhY2UgaXMg
Zm9yIExpbmtzeXMgQVBzICovCkBAIC04NSw5ICs4NSwxMCBAQCBzdGF0aWMgaW50IGl3bF9pc19l
bXB0eV9lc3NpZChjb25zdCBjaGFyICplc3NpZCwgaW50IGVzc2lkX2xlbikKIAogCXJldHVybiAx
OwogfQorI2VuZGlmIC8qIENPTkZJR19JV0xXSUZJX0RFQlVHICovCiAKIAotCisjaWZkZWYgQ09O
RklHX0lXTFdJRklfREVCVUcKIHN0YXRpYyBjb25zdCBjaGFyICppd2xfZXNjYXBlX2Vzc2lkKGNv
bnN0IGNoYXIgKmVzc2lkLCB1OCBlc3NpZF9sZW4pCiB7CiAJc3RhdGljIGNoYXIgZXNjYXBlZFtJ
V19FU1NJRF9NQVhfU0laRSAqIDIgKyAxXTsKQEAgLTExMSw3ICsxMTIsNyBAQCBzdGF0aWMgY29u
c3QgY2hhciAqaXdsX2VzY2FwZV9lc3NpZChjb25zdCBjaGFyICplc3NpZCwgdTggZXNzaWRfbGVu
KQogCSpkID0gJ1wwJzsKIAlyZXR1cm4gZXNjYXBlZDsKIH0KLQorI2VuZGlmIC8qIENPTkZJR19J
V0xXSUZJX0RFQlVHICovCiAvKioKICAqIGl3bF9zY2FuX2NhbmNlbCAtIENhbmNlbCBhbnkgY3Vy
cmVudGx5IGV4ZWN1dGluZyBIVyBzY2FuCiAgKgo=
------=_Part_55867_27800426.1223301567145--
