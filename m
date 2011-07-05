Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46289 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1GEN33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 09:29:29 -0400
Received: by wyg8 with SMTP id 8so3987932wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 06:29:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110705124914.GC26882@alittletooquiet.net>
References: <20110701133553.GA7125@alittletooquiet.net>
	<BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
	<BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
	<20110701173237.GC7125@alittletooquiet.net>
	<20110704052410.GA1364@vmraj-lnx.users.atheros.com>
	<20110704095341.GA1380@vmraj-lnx.users.atheros.com>
	<20110705124914.GC26882@alittletooquiet.net>
Date: Tue, 5 Jul 2011 18:59:27 +0530
Message-ID: <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com> (sfid-20110705_152933_509386_11E8AB7C)
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless 3.0-rc4-1
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=00221597639e195c7304a75279d3
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00221597639e195c7304a75279d3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>> > Please share your PID/VID.
>
> 0cf3:9271
>
>> And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 and fw=
 size
>> should be 51272. But in your case size is 51288 which is 1.2. Please upg=
rade fw
>> to 1.3 and test again.
>>
>> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw
>
> Okay. =A0I had tried both versions previously; neither seems to work any =
better
> than the other. =A0Here is dmesg using firmware version 1.3:
>
> [ =A0102.984766] Compat-wireless backport release: compat-wireless-v3.0-r=
c4-1
> [ =A0102.984775] Backport based on linux-2.6-allstable.git v3.0-rc4
> [ =A0103.213468] Calling CRDA to update world regulatory domain
> [ =A0103.798281] usbcore: registered new interface driver ath9k_htc
> [ =A0108.482070] usb 5-7: new high speed USB device using ehci_hcd and ad=
dress 5
> [ =A0108.643105] usb 5-7: configuration #1 chosen from 1 choice
> [ =A0108.996663] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 5=
1272
> [ =A0109.135499] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 cr=
edits
> [ =A0109.140526] ath: UNDEFINED -> AWAKE
> [ =A0109.141769] ath: serialize_regmode is 0
> [ =A0109.383151] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDI=
D
> [ =A0109.383168] ath: REGISTER WRITE FAILED, multi len: 9
> [ =A0109.609805] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0109.609822] ath: REGISTER READ FAILED: (0x9c00, -110)
> [ =A0109.609835] ath: Reading from EEPROM, not flash
> [ =A0109.824058] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0109.824079] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0110.042132] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0110.042148] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0110.260786] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0110.260802] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0110.482613] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0110.482629] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0110.719736] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0110.719753] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0110.953628] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0110.953645] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0111.195035] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0111.195057] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0111.432953] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0111.432975] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0111.668211] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0111.668227] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0111.903626] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0111.903642] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0112.135695] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0112.135711] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0112.370919] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0112.370936] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0112.603491] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0112.603508] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0112.841972] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0112.841988] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0113.065412] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0113.065428] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0113.300441] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0113.300458] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0113.536889] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0113.536906] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0113.774809] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0113.774826] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0114.012001] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0114.012018] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0114.245297] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0114.245314] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0114.476929] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0114.476946] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0114.753310] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0114.753327] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0114.966595] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0114.966611] ath: Multiple REGISTER READ FAILED (count: 8)
> [ =A0115.193618] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0115.193634] ath: Multiple REGISTER READ FAILED (count: 4)
> [ =A0115.462402] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0115.462419] ath: REGISTER READ FAILED: (0x2000, -110)
> [ =A0115.685667] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0115.685684] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0115.918681] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0115.918703] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0116.152756] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0116.152773] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0116.391881] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0116.391898] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0116.629244] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0116.629265] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0116.860197] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0116.860214] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0117.094108] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0117.094124] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0117.325535] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0117.325551] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0117.578615] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0117.578632] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0117.819951] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0117.819968] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0118.055933] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0118.055950] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0118.329876] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0118.329893] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0118.563992] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0118.564009] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0118.803279] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0118.803296] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0119.045193] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0119.045209] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0119.294820] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0119.294832] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0119.536403] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0119.536421] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0119.764358] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0119.764375] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0120.002647] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0120.002664] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0120.223089] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0120.223107] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0120.450418] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0120.450435] ath: REGISTER READ FAILED: (0x407c, -110)
> [ =A0120.701625] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> [ =A0120.701638] ath: REGISTER READ FAILED: (0x407c, -110)

please try to apply the attached reverting patch, if it works it may
help us to narrow down the issue.
Thanks.

>
> I appreciate your help on this.
>
> Thanks,
> Forest
> --
> Forest Bond
> http://www.alittletooquiet.net
> http://www.rapidrollout.com
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk4TCEoACgkQRO4fQQdv5AzU1QCfTLes04IZ3F9Zrdo+WdMQ6Kg8
> bV8AoI0CgOsrqwPnSxGA/NMPZFAXmsbP
> =3D0xqn
> -----END PGP SIGNATURE-----
>
>



--=20
shafi

--00221597639e195c7304a75279d3
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-Revert-ath9k_hw-Offload-USB-eeprom-reading-to-target.patch"
Content-Disposition: attachment;
	filename="0001-Revert-ath9k_hw-Offload-USB-eeprom-reading-to-target.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpqw72d11

RnJvbSA3MTM3NDMzNWUwZmZhMjk5Nzc1YmUwM2Y5OWYyNjVhMDJiYmE0MzQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBTaGFmaSBTaGFqYWtoYW4gPG1vaGFtbWVkQHFj
YS5xdWFsY29tbS5jb20+CkRhdGU6IFR1ZSwgNSBKdWwgMjAxMSAxODo0ODoxMCArMDUzMApTdWJq
ZWN0OiBbUEFUQ0hdIFJldmVydCAiYXRoOWtfaHc6IE9mZmxvYWQgVVNCIGVlcHJvbSByZWFkaW5n
IHRvIHRhcmdldCIKClRoaXMgcmV2ZXJ0cyBjb21taXQgMDRjZjUzZjQ2NTA0OWM3YzUwOWFhYzdi
Nzc2Zjc1ZDM4ZWY2OGU2OS4KClNpZ25lZC1vZmYtYnk6IE1vaGFtbWVkIFNoYWZpIFNoYWpha2hh
biA8bW9oYW1tZWRAcWNhLnF1YWxjb21tLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvZWVwcm9tLmMgICAgICB8ICAgMzIgLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoOWsvZWVwcm9tLmggICAgICB8ICAgIDIgLQogZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2VlcHJvbV80ay5jICAgfCAgIDQxICsrKysrKy0tLS0tLS0t
LS0tLS0tLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvZWVwcm9tXzkyODcuYyB8
ICAgNDUgKysrKysrKystLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL2VlcHJvbV9kZWYuYyAgfCAgIDMyICsrLS0tLS0tLS0tLS0tLS0tLQogNSBmaWxlcyBj
aGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCAxMjMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2VlcHJvbS5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDlrL2VlcHJvbS5jCmluZGV4IGU2MTQwNGQuLmE0YTQxMDAgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9lZXByb20uYworKysgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoOWsvZWVwcm9tLmMKQEAgLTg5LDM4ICs4OSw2IEBAIGJvb2wg
YXRoOWtfaHdfZ2V0X2xvd2VyX3VwcGVyX2luZGV4KHU4IHRhcmdldCwgdTggKnBMaXN0LCB1MTYg
bGlzdFNpemUsCiAJcmV0dXJuIGZhbHNlOwogfQogCi12b2lkIGF0aDlrX2h3X3VzYl9nZW5fZmls
bF9lZXByb20oc3RydWN0IGF0aF9odyAqYWgsIHUxNiAqZWVwX2RhdGEsCi0JCQkJICBpbnQgZWVw
X3N0YXJ0X2xvYywgaW50IHNpemUpCi17Ci0JaW50IGkgPSAwLCBqLCBhZGRyOwotCXUzMiBhZGRy
ZGF0YVs4XTsKLQl1MzIgZGF0YVs4XTsKLQotCWZvciAoYWRkciA9IDA7IGFkZHIgPCBzaXplOyBh
ZGRyKyspIHsKLQkJYWRkcmRhdGFbaV0gPSBBUjU0MTZfRUVQUk9NX09GRlNFVCArCi0JCQkoKGFk
ZHIgKyBlZXBfc3RhcnRfbG9jKSA8PCBBUjU0MTZfRUVQUk9NX1MpOwotCQlpKys7Ci0JCWlmIChp
ID09IDgpIHsKLQkJCVJFR19SRUFEX01VTFRJKGFoLCBhZGRyZGF0YSwgZGF0YSwgaSk7Ci0KLQkJ
CWZvciAoaiA9IDA7IGogPCBpOyBqKyspIHsKLQkJCQkqZWVwX2RhdGEgPSBkYXRhW2pdOwotCQkJ
CWVlcF9kYXRhKys7Ci0JCQl9Ci0JCQlpID0gMDsKLQkJfQotCX0KLQotCWlmIChpICE9IDApIHsK
LQkJUkVHX1JFQURfTVVMVEkoYWgsIGFkZHJkYXRhLCBkYXRhLCBpKTsKLQotCQlmb3IgKGogPSAw
OyBqIDwgaTsgaisrKSB7Ci0JCQkqZWVwX2RhdGEgPSBkYXRhW2pdOwotCQkJZWVwX2RhdGErKzsK
LQkJfQotCX0KLX0KLQogYm9vbCBhdGg5a19od19udnJhbV9yZWFkKHN0cnVjdCBhdGhfY29tbW9u
ICpjb21tb24sIHUzMiBvZmYsIHUxNiAqZGF0YSkKIHsKIAlyZXR1cm4gY29tbW9uLT5idXNfb3Bz
LT5lZXByb21fcmVhZChjb21tb24sIG9mZiwgZGF0YSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvZWVwcm9tLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoOWsvZWVwcm9tLmgKaW5kZXggZGU5OWMwZC4uZmMzYjYyMCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2VlcHJvbS5oCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay9lZXByb20uaApAQCAtNjY5LDggKzY2OSw2IEBAIGludDE2X3QgYXRoOWtf
aHdfaW50ZXJwb2xhdGUodTE2IHRhcmdldCwgdTE2IHNyY0xlZnQsIHUxNiBzcmNSaWdodCwKIGJv
b2wgYXRoOWtfaHdfZ2V0X2xvd2VyX3VwcGVyX2luZGV4KHU4IHRhcmdldCwgdTggKnBMaXN0LCB1
MTYgbGlzdFNpemUsCiAJCQkJICAgIHUxNiAqaW5kZXhMLCB1MTYgKmluZGV4Uik7CiBib29sIGF0
aDlrX2h3X252cmFtX3JlYWQoc3RydWN0IGF0aF9jb21tb24gKmNvbW1vbiwgdTMyIG9mZiwgdTE2
ICpkYXRhKTsKLXZvaWQgYXRoOWtfaHdfdXNiX2dlbl9maWxsX2VlcHJvbShzdHJ1Y3QgYXRoX2h3
ICphaCwgdTE2ICplZXBfZGF0YSwKLQkJCQkgIGludCBlZXBfc3RhcnRfbG9jLCBpbnQgc2l6ZSk7
CiB2b2lkIGF0aDlrX2h3X2ZpbGxfdnBkX3RhYmxlKHU4IHB3ck1pbiwgdTggcHdyTWF4LCB1OCAq
cFB3ckxpc3QsCiAJCQkgICAgIHU4ICpwVnBkTGlzdCwgdTE2IG51bUludGVyY2VwdHMsCiAJCQkg
ICAgIHU4ICpwUmV0VnBkTGlzdCk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvZWVwcm9tXzRrLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvZWVw
cm9tXzRrLmMKaW5kZXggNWIxZTg5NC4uODY3Y2I4OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDlrL2VlcHJvbV80ay5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9lZXByb21fNGsuYwpAQCAtMjcsMTMgKzI3LDE5IEBAIHN0YXRpYyBpbnQgYXRo
OWtfaHdfNGtfZ2V0X2VlcHJvbV9yZXYoc3RydWN0IGF0aF9odyAqYWgpCiAJcmV0dXJuICgoYWgt
PmVlcHJvbS5tYXA0ay5iYXNlRWVwSGVhZGVyLnZlcnNpb24pICYgMHhGRkYpOwogfQogCi0jZGVm
aW5lIFNJWkVfRUVQUk9NXzRLIChzaXplb2Yoc3RydWN0IGFyNTQxNl9lZXByb21fNGspIC8gc2l6
ZW9mKHUxNikpCi0KLXN0YXRpYyBib29sIF9fYXRoOWtfaHdfNGtfZmlsbF9lZXByb20oc3RydWN0
IGF0aF9odyAqYWgpCitzdGF0aWMgYm9vbCBhdGg5a19od180a19maWxsX2VlcHJvbShzdHJ1Y3Qg
YXRoX2h3ICphaCkKIHsKKyNkZWZpbmUgU0laRV9FRVBST01fNEsgKHNpemVvZihzdHJ1Y3QgYXI1
NDE2X2VlcHJvbV80aykgLyBzaXplb2YodTE2KSkKIAlzdHJ1Y3QgYXRoX2NvbW1vbiAqY29tbW9u
ID0gYXRoOWtfaHdfY29tbW9uKGFoKTsKIAl1MTYgKmVlcF9kYXRhID0gKHUxNiAqKSZhaC0+ZWVw
cm9tLm1hcDRrOwotCWludCBhZGRyLCBlZXBfc3RhcnRfbG9jID0gNjQ7CisJaW50IGFkZHIsIGVl
cF9zdGFydF9sb2MgPSAwOworCisJZWVwX3N0YXJ0X2xvYyA9IDY0OworCisJaWYgKCFhdGg5a19o
d191c2VfZmxhc2goYWgpKSB7CisJCWF0aF9kYmcoY29tbW9uLCBBVEhfREJHX0VFUFJPTSwKKwkJ
CSJSZWFkaW5nIGZyb20gRUVQUk9NLCBub3QgZmxhc2hcbiIpOworCX0KIAogCWZvciAoYWRkciA9
IDA7IGFkZHIgPCBTSVpFX0VFUFJPTV80SzsgYWRkcisrKSB7CiAJCWlmICghYXRoOWtfaHdfbnZy
YW1fcmVhZChjb21tb24sIGFkZHIgKyBlZXBfc3RhcnRfbG9jLCBlZXBfZGF0YSkpIHsKQEAgLTQ1
LDMzICs1MSw4IEBAIHN0YXRpYyBib29sIF9fYXRoOWtfaHdfNGtfZmlsbF9lZXByb20oc3RydWN0
IGF0aF9odyAqYWgpCiAJfQogCiAJcmV0dXJuIHRydWU7Ci19Ci0KLXN0YXRpYyBib29sIF9fYXRo
OWtfaHdfdXNiXzRrX2ZpbGxfZWVwcm9tKHN0cnVjdCBhdGhfaHcgKmFoKQotewotCXUxNiAqZWVw
X2RhdGEgPSAodTE2ICopJmFoLT5lZXByb20ubWFwNGs7Ci0KLQlhdGg5a19od191c2JfZ2VuX2Zp
bGxfZWVwcm9tKGFoLCBlZXBfZGF0YSwgNjQsIFNJWkVfRUVQUk9NXzRLKTsKLQotCXJldHVybiB0
cnVlOwotfQotCi1zdGF0aWMgYm9vbCBhdGg5a19od180a19maWxsX2VlcHJvbShzdHJ1Y3QgYXRo
X2h3ICphaCkKLXsKLQlzdHJ1Y3QgYXRoX2NvbW1vbiAqY29tbW9uID0gYXRoOWtfaHdfY29tbW9u
KGFoKTsKLQotCWlmICghYXRoOWtfaHdfdXNlX2ZsYXNoKGFoKSkgewotCQlhdGhfZGJnKGNvbW1v
biwgQVRIX0RCR19FRVBST00sCi0JCQkiUmVhZGluZyBmcm9tIEVFUFJPTSwgbm90IGZsYXNoXG4i
KTsKLQl9Ci0KLQlpZiAoY29tbW9uLT5idXNfb3BzLT5hdGhfYnVzX3R5cGUgPT0gQVRIX1VTQikK
LQkJcmV0dXJuIF9fYXRoOWtfaHdfdXNiXzRrX2ZpbGxfZWVwcm9tKGFoKTsKLQllbHNlCi0JCXJl
dHVybiBfX2F0aDlrX2h3XzRrX2ZpbGxfZWVwcm9tKGFoKTsKLX0KLQogI3VuZGVmIFNJWkVfRUVQ
Uk9NXzRLCit9CiAKIHN0YXRpYyBpbnQgYXRoOWtfaHdfNGtfY2hlY2tfZWVwcm9tKHN0cnVjdCBh
dGhfaHcgKmFoKQogewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2VlcHJvbV85Mjg3LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvZWVwcm9tXzky
ODcuYwppbmRleCAzNDNmYzlmLi43MDE1NTQ3IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoOWsvZWVwcm9tXzkyODcuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvZWVwcm9tXzkyODcuYwpAQCAtMTcsNyArMTcsNyBAQAogI2luY2x1ZGUgImh3Lmgi
CiAjaW5jbHVkZSAiYXI5MDAyX3BoeS5oIgogCi0jZGVmaW5lIFNJWkVfRUVQUk9NX0FSOTI4NyAo
c2l6ZW9mKHN0cnVjdCBhcjkyODdfZWVwcm9tKSAvIHNpemVvZih1MTYpKQorI2RlZmluZSBOVU1f
RUVQX1dPUkRTIChzaXplb2Yoc3RydWN0IGFyOTI4N19lZXByb20pIC8gc2l6ZW9mKHUxNikpCiAK
IHN0YXRpYyBpbnQgYXRoOWtfaHdfYXI5Mjg3X2dldF9lZXByb21fdmVyKHN0cnVjdCBhdGhfaHcg
KmFoKQogewpAQCAtMjksMTUgKzI5LDI1IEBAIHN0YXRpYyBpbnQgYXRoOWtfaHdfYXI5Mjg3X2dl
dF9lZXByb21fcmV2KHN0cnVjdCBhdGhfaHcgKmFoKQogCXJldHVybiAoYWgtPmVlcHJvbS5tYXA5
Mjg3LmJhc2VFZXBIZWFkZXIudmVyc2lvbikgJiAweEZGRjsKIH0KIAotc3RhdGljIGJvb2wgX19h
dGg5a19od19hcjkyODdfZmlsbF9lZXByb20oc3RydWN0IGF0aF9odyAqYWgpCitzdGF0aWMgYm9v
bCBhdGg5a19od19hcjkyODdfZmlsbF9lZXByb20oc3RydWN0IGF0aF9odyAqYWgpCiB7CiAJc3Ry
dWN0IGFyOTI4N19lZXByb20gKmVlcCA9ICZhaC0+ZWVwcm9tLm1hcDkyODc7CiAJc3RydWN0IGF0
aF9jb21tb24gKmNvbW1vbiA9IGF0aDlrX2h3X2NvbW1vbihhaCk7CiAJdTE2ICplZXBfZGF0YTsK
LQlpbnQgYWRkciwgZWVwX3N0YXJ0X2xvYyA9IEFSOTI4N19FRVBfU1RBUlRfTE9DOworCWludCBh
ZGRyLCBlZXBfc3RhcnRfbG9jOwogCWVlcF9kYXRhID0gKHUxNiAqKWVlcDsKIAotCWZvciAoYWRk
ciA9IDA7IGFkZHIgPCBTSVpFX0VFUFJPTV9BUjkyODc7IGFkZHIrKykgeworCWlmIChjb21tb24t
PmJ1c19vcHMtPmF0aF9idXNfdHlwZSA9PSBBVEhfVVNCKQorCQllZXBfc3RhcnRfbG9jID0gQVI5
Mjg3X0hUQ19FRVBfU1RBUlRfTE9DOworCWVsc2UKKwkJZWVwX3N0YXJ0X2xvYyA9IEFSOTI4N19F
RVBfU1RBUlRfTE9DOworCisJaWYgKCFhdGg5a19od191c2VfZmxhc2goYWgpKSB7CisJCWF0aF9k
YmcoY29tbW9uLCBBVEhfREJHX0VFUFJPTSwKKwkJCSJSZWFkaW5nIGZyb20gRUVQUk9NLCBub3Qg
Zmxhc2hcbiIpOworCX0KKworCWZvciAoYWRkciA9IDA7IGFkZHIgPCBOVU1fRUVQX1dPUkRTOyBh
ZGRyKyspIHsKIAkJaWYgKCFhdGg5a19od19udnJhbV9yZWFkKGNvbW1vbiwgYWRkciArIGVlcF9z
dGFydF9sb2MsCiAJCQkJCSBlZXBfZGF0YSkpIHsKIAkJCWF0aF9kYmcoY29tbW9uLCBBVEhfREJH
X0VFUFJPTSwKQEAgLTUwLDMxICs2MCw2IEBAIHN0YXRpYyBib29sIF9fYXRoOWtfaHdfYXI5Mjg3
X2ZpbGxfZWVwcm9tKHN0cnVjdCBhdGhfaHcgKmFoKQogCXJldHVybiB0cnVlOwogfQogCi1zdGF0
aWMgYm9vbCBfX2F0aDlrX2h3X3VzYl9hcjkyODdfZmlsbF9lZXByb20oc3RydWN0IGF0aF9odyAq
YWgpCi17Ci0JdTE2ICplZXBfZGF0YSA9ICh1MTYgKikmYWgtPmVlcHJvbS5tYXA5Mjg3OwotCi0J
YXRoOWtfaHdfdXNiX2dlbl9maWxsX2VlcHJvbShhaCwgZWVwX2RhdGEsCi0JCQkJICAgICBBUjky
ODdfSFRDX0VFUF9TVEFSVF9MT0MsCi0JCQkJICAgICBTSVpFX0VFUFJPTV9BUjkyODcpOwotCXJl
dHVybiB0cnVlOwotfQotCi1zdGF0aWMgYm9vbCBhdGg5a19od19hcjkyODdfZmlsbF9lZXByb20o
c3RydWN0IGF0aF9odyAqYWgpCi17Ci0Jc3RydWN0IGF0aF9jb21tb24gKmNvbW1vbiA9IGF0aDlr
X2h3X2NvbW1vbihhaCk7Ci0KLQlpZiAoIWF0aDlrX2h3X3VzZV9mbGFzaChhaCkpIHsKLQkJYXRo
X2RiZyhjb21tb24sIEFUSF9EQkdfRUVQUk9NLAotCQkJIlJlYWRpbmcgZnJvbSBFRVBST00sIG5v
dCBmbGFzaFxuIik7Ci0JfQotCi0JaWYgKGNvbW1vbi0+YnVzX29wcy0+YXRoX2J1c190eXBlID09
IEFUSF9VU0IpCi0JCXJldHVybiBfX2F0aDlrX2h3X3VzYl9hcjkyODdfZmlsbF9lZXByb20oYWgp
OwotCWVsc2UKLQkJcmV0dXJuIF9fYXRoOWtfaHdfYXI5Mjg3X2ZpbGxfZWVwcm9tKGFoKTsKLX0K
LQogc3RhdGljIGludCBhdGg5a19od19hcjkyODdfY2hlY2tfZWVwcm9tKHN0cnVjdCBhdGhfaHcg
KmFoKQogewogCXUzMiBzdW0gPSAwLCBlbCwgaW50ZWdlcjsKQEAgLTEwMSw3ICs4Niw3IEBAIHN0
YXRpYyBpbnQgYXRoOWtfaHdfYXI5Mjg3X2NoZWNrX2VlcHJvbShzdHJ1Y3QgYXRoX2h3ICphaCkK
IAkJCQluZWVkX3N3YXAgPSB0cnVlOwogCQkJCWVlcGRhdGEgPSAodTE2ICopKCZhaC0+ZWVwcm9t
KTsKIAotCQkJCWZvciAoYWRkciA9IDA7IGFkZHIgPCBTSVpFX0VFUFJPTV9BUjkyODc7IGFkZHIr
KykgeworCQkJCWZvciAoYWRkciA9IDA7IGFkZHIgPCBOVU1fRUVQX1dPUkRTOyBhZGRyKyspIHsK
IAkJCQkJdGVtcCA9IHN3YWIxNigqZWVwZGF0YSk7CiAJCQkJCSplZXBkYXRhID0gdGVtcDsKIAkJ
CQkJZWVwZGF0YSsrOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2VlcHJvbV9kZWYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9lZXByb21fZGVm
LmMKaW5kZXggMTdmMGE2OC4uNTFlNzI4NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL2VlcHJvbV9kZWYuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoOWsvZWVwcm9tX2RlZi5jCkBAIC04NiwxMCArODYsOSBAQCBzdGF0aWMgaW50IGF0aDlrX2h3
X2RlZl9nZXRfZWVwcm9tX3JldihzdHJ1Y3QgYXRoX2h3ICphaCkKIAlyZXR1cm4gKChhaC0+ZWVw
cm9tLmRlZi5iYXNlRWVwSGVhZGVyLnZlcnNpb24pICYgMHhGRkYpOwogfQogCi0jZGVmaW5lIFNJ
WkVfRUVQUk9NX0RFRiAoc2l6ZW9mKHN0cnVjdCBhcjU0MTZfZWVwcm9tX2RlZikgLyBzaXplb2Yo
dTE2KSkKLQotc3RhdGljIGJvb2wgX19hdGg5a19od19kZWZfZmlsbF9lZXByb20oc3RydWN0IGF0
aF9odyAqYWgpCitzdGF0aWMgYm9vbCBhdGg5a19od19kZWZfZmlsbF9lZXByb20oc3RydWN0IGF0
aF9odyAqYWgpCiB7CisjZGVmaW5lIFNJWkVfRUVQUk9NX0RFRiAoc2l6ZW9mKHN0cnVjdCBhcjU0
MTZfZWVwcm9tX2RlZikgLyBzaXplb2YodTE2KSkKIAlzdHJ1Y3QgYXRoX2NvbW1vbiAqY29tbW9u
ID0gYXRoOWtfaHdfY29tbW9uKGFoKTsKIAl1MTYgKmVlcF9kYXRhID0gKHUxNiAqKSZhaC0+ZWVw
cm9tLmRlZjsKIAlpbnQgYWRkciwgYXI1NDE2X2VlcF9zdGFydF9sb2MgPSAweDEwMDsKQEAgLTEw
NCwzMyArMTAzLDggQEAgc3RhdGljIGJvb2wgX19hdGg5a19od19kZWZfZmlsbF9lZXByb20oc3Ry
dWN0IGF0aF9odyAqYWgpCiAJCWVlcF9kYXRhKys7CiAJfQogCXJldHVybiB0cnVlOwotfQotCi1z
dGF0aWMgYm9vbCBfX2F0aDlrX2h3X3VzYl9kZWZfZmlsbF9lZXByb20oc3RydWN0IGF0aF9odyAq
YWgpCi17Ci0JdTE2ICplZXBfZGF0YSA9ICh1MTYgKikmYWgtPmVlcHJvbS5kZWY7Ci0KLQlhdGg5
a19od191c2JfZ2VuX2ZpbGxfZWVwcm9tKGFoLCBlZXBfZGF0YSwKLQkJCQkgICAgIDB4MTAwLCBT
SVpFX0VFUFJPTV9ERUYpOwotCXJldHVybiB0cnVlOwotfQotCi1zdGF0aWMgYm9vbCBhdGg5a19o
d19kZWZfZmlsbF9lZXByb20oc3RydWN0IGF0aF9odyAqYWgpCi17Ci0Jc3RydWN0IGF0aF9jb21t
b24gKmNvbW1vbiA9IGF0aDlrX2h3X2NvbW1vbihhaCk7Ci0KLQlpZiAoIWF0aDlrX2h3X3VzZV9m
bGFzaChhaCkpIHsKLQkJYXRoX2RiZyhjb21tb24sIEFUSF9EQkdfRUVQUk9NLAotCQkJIlJlYWRp
bmcgZnJvbSBFRVBST00sIG5vdCBmbGFzaFxuIik7Ci0JfQotCi0JaWYgKGNvbW1vbi0+YnVzX29w
cy0+YXRoX2J1c190eXBlID09IEFUSF9VU0IpCi0JCXJldHVybiBfX2F0aDlrX2h3X3VzYl9kZWZf
ZmlsbF9lZXByb20oYWgpOwotCWVsc2UKLQkJcmV0dXJuIF9fYXRoOWtfaHdfZGVmX2ZpbGxfZWVw
cm9tKGFoKTsKLX0KLQogI3VuZGVmIFNJWkVfRUVQUk9NX0RFRgorfQogCiBzdGF0aWMgaW50IGF0
aDlrX2h3X2RlZl9jaGVja19lZXByb20oc3RydWN0IGF0aF9odyAqYWgpCiB7Ci0tIAoxLjcuMC40
Cgo=
--00221597639e195c7304a75279d3--
