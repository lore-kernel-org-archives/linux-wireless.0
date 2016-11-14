Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm2-vm2.bullet.mail.ir2.yahoo.com ([212.82.96.82]:53275 "EHLO
        nm2-vm2.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752376AbcKNLsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 06:48:39 -0500
Date: Mon, 14 Nov 2016 11:47:45 +0000 (UTC)
From: Gianfranco Costamagna <locutusofborg@debian.org>
Reply-To: Gianfranco Costamagna <locutusofborg@debian.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
Message-ID: <810879191.6335567.1479124065921@mail.yahoo.com> (sfid-20161114_124845_442654_77882AEB)
In-Reply-To: <fba3cf06-917f-f1c9-6735-f166a18aa222@broadcom.com>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com> <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com> <690669269.1124561.1477671348137@mail.yahoo.com> <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com> <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com> <233918815.6357602.1479123253455@mail.yahoo.com> <fba3cf06-917f-f1c9-6735-f166a18aa222@broadcom.com>
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_Part_6335566_1331583645.1479124065921"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_6335566_1331583645.1479124065921
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Arend,



>Well, not before you pointed it out ;-). You are welcome to send a patch
>fixing it. Otherwise, I will take care of it.


attaching a format-patch like version.
I don't think we need a Tested-by or whatever, because it is just a typo in a comment.
(this is my first contribution, feel free to rebase or change whatever you prefer
to make it in line with other styles)

(I gave authorship to Marco, the first one who discovered such typo)

thanks!

G.

------=_Part_6335566_1331583645.1479124065921
Content-Type: text/x-diff
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0=0001-cfg80211-fix-typo-in-REG-channel-frequency-comment.patc;
	filename*1=h
Content-ID: <3d3e2742-fe31-3bbe-fcea-7d44252f03c2@yahoo.com>

RnJvbSBiZjBjZGQ4YWQyNzgzMzYzOTQ0N2EzMDcxZDY2MmY3OWE3MjE5YjFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcmxvbmUgTWFyY28gPG1hcmNvLmFybG9uZUByb2ouY29tPgpE
YXRlOiBTYXQsIDIyIE9jdCAyMDE2IDE1OjA4OjM1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gYnJv
YWRjb20gY2ZnODAyMTE6IGZpeCB0eXBvIGluIFJFRyBjaGFubmVsIGZyZXF1ZW5jeSBjb21tZW50
CgpmcmVxdWVuY3kgMjQ3MiBjb3JyZXNwb25kcyB0byBjaGFubmVsIDEzLCBub3QgY2hhbm5lbCAx
MQoKU2lnbmVkLW9mZi1ieTogR2lhbmZyYW5jbyBDb3N0YW1hZ25hIDxnaWFuZnJhbmNvLmNvc3Rh
bWFnbmFAYWJpbnN1bGEuY29tPgpTaWduZWQtb2ZmLWJ5OiBOaWNvbGEgU21hbGRvbmUgPG5pY29s
YS5zbWFsZG9uZUB0aWVycmFzZXJ2aWNlLmNvbT4KU2lnbmVkLW9mZi1ieTogQXJsb25lIE1hcmNv
IDxtYXJjby5hcmxvbmVAcm9qLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNv
bS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jZmc4MDIxMS5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMKaW5kZXgg
Yjc3N2UxYi4uYjRkOGIxYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMKQEAgLTIwMyw3ICsyMDMs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9yZWdkb21haW4gYnJjbWZfcmVnZG9t
ID0gewogCS5uX3JlZ19ydWxlcyA9IDQsCiAJLmFscGhhMiA9ICAiOTkiLAogCS5yZWdfcnVsZXMg
PSB7Ci0JCS8qIElFRUUgODAyLjExYi9nLCBjaGFubmVscyAxLi4xMSAqLworCQkvKiBJRUVFIDgw
Mi4xMWIvZywgY2hhbm5lbHMgMS4uMTMgKi8KIAkJUkVHX1JVTEUoMjQxMi0xMCwgMjQ3MisxMCwg
NDAsIDYsIDIwLCAwKSwKIAkJLyogSWYgYW55ICovCiAJCS8qIElFRUUgODAyLjExIGNoYW5uZWwg
MTQgLSBPbmx5IEpQIGVuYWJsZXMKLS0gCjIuNy40Cgo=

------=_Part_6335566_1331583645.1479124065921--
