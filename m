Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:33297 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754704AbdCIP5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 10:57:15 -0500
Received: by mail-ua0-f170.google.com with SMTP id u30so85641751uau.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 07:57:14 -0800 (PST)
MIME-Version: 1.0
From: Rostyslav Khudolii <rkhudolii@airtame.com>
Date: Thu, 9 Mar 2017 16:57:13 +0100
Message-ID: <CAPXt_dY_qFkm0uNEB7AB1FG=pn6MJBS5g3GiejXJGfeTn2r48w@mail.gmail.com> (sfid-20170309_165717_860639_34AE4325)
Subject: ath6kl: Remove old 802.11a-only channels
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
        Attila Sukosd <attila@airtame.com>
Content-Type: multipart/mixed; boundary=94eb2c0484486c069e054a4e4c3a
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--94eb2c0484486c069e054a4e4c3a
Content-Type: text/plain; charset=UTF-8

Hi Kalle,

Following our conversation ("AR6003 5.2GHz AP on channel 38") on the
mailing list, sending a patch which removes channels 34/38/42/46 from
ath6kl driver.

Regards,
Rostyslav

--94eb2c0484486c069e054a4e4c3a
Content-Type: application/octet-stream;
	name="0001-ath6kl-Remove-old-802.11a-only-channels.patch"
Content-Disposition: attachment;
	filename="0001-ath6kl-Remove-old-802.11a-only-channels.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j02ksso80

RnJvbSA0M2IwYTAzZTQxOTEzOTE5MDQ2ZTcyZThkN2Q3YmEzZDkyOGUxOTg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb3N0eXNsYXYgS2h1ZG9saWkgPHJraHVkb2xpaUBhaXJ0YW1l
LmNvbT4KRGF0ZTogVHVlLCA3IE1hciAyMDE3IDExOjEwOjMxICswMTAwClN1YmplY3Q6IFtQQVRD
SF0gYXRoNmtsOiBSZW1vdmUgb2xkIDgwMi4xMWEtb25seSBjaGFubmVscwoKQ2hhbm5lbHMgMzQv
MzgvNDIvNDYgY2FuIG9ubHkgYmUgdXNlZCBmb3IgY29tcGF0aWJpbGl0eSB3aXRoCm9sZCBkZXZp
Y2VzIHNvbGQgaW4gSmFwYW4uIE1vZGVybiBwcm9kdWN0cywgc3VjaCBhcyBBUjYwMDMvQVI2MDA0
CmRvbid0IHN1cHBvcnQgdGhlc2UgY2hhbm5lbHMuCktlZXBpbmcgdGhlbSBpbiB0aGUgdXBzdHJl
YW0gaXMgZXJyb3IgcHJvbmUgYW5kIHJlcXVpcmVzIGZ1bGwKbmV0d29yayBzdGFjayBzdXBwb3J0
LgpBIGN1c3RvbSBwYXRjaCBzaG91bGQgYmUgdXNlZCBpbiBjYXNlIHN1Y2ggY29tcGF0aWJpbGl0
eSBpcyByZXF1aXJlZC4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2NmZzgw
MjExLmMgfCA2ICsrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2Nm
ZzgwMjExLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2NmZzgwMjExLmMKaW5k
ZXggMzYzYjMwYS4uYWFlNjVjZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDZrbC9jZmc4MDIxMS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wv
Y2ZnODAyMTEuYwpAQCAtMTAyLDEwICsxMDIsOCBAQCBzdGF0aWMgc3RydWN0IGllZWU4MDIxMV9j
aGFubmVsIGF0aDZrbF8yZ2h6X2NoYW5uZWxzW10gPSB7CiB9OwogCiBzdGF0aWMgc3RydWN0IGll
ZWU4MDIxMV9jaGFubmVsIGF0aDZrbF81Z2h6X2FfY2hhbm5lbHNbXSA9IHsKLQlDSEFONUcoMzQs
IDApLCBDSEFONUcoMzYsIDApLAotCUNIQU41RygzOCwgMCksIENIQU41Ryg0MCwgMCksCi0JQ0hB
TjVHKDQyLCAwKSwgQ0hBTjVHKDQ0LCAwKSwKLQlDSEFONUcoNDYsIDApLCBDSEFONUcoNDgsIDAp
LAorCUNIQU41RygzNiwgMCksIENIQU41Ryg0MCwgMCksCisJQ0hBTjVHKDQ0LCAwKSwgQ0hBTjVH
KDQ4LCAwKSwKIAlDSEFONUcoNTIsIDApLCBDSEFONUcoNTYsIDApLAogCUNIQU41Ryg2MCwgMCks
IENIQU41Ryg2NCwgMCksCiAJQ0hBTjVHKDEwMCwgMCksIENIQU41RygxMDQsIDApLAotLSAKMi45
LjMKCg==
--94eb2c0484486c069e054a4e4c3a--
