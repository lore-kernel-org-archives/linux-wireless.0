Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:21534 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762288AbXLTQKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 11:10:06 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1825176nze.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2007 08:10:05 -0800 (PST)
Message-ID: <cb0375e10712200810n4c12e2dldbf67c17ebcd34d0@mail.gmail.com> (sfid-20071220_161013_069484_4612AA93)
Date: Thu, 20 Dec 2007 11:10:05 -0500
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] make iw usable for mere mortals
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_18275_27558758.1198167005230"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_18275_27558758.1198167005230
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[Sorry for attached patch, but I fully expect my mailer to butcher it
otherwise.]

iw currently works, but the error handling is a bit off, many error
messages are absent, and the help text is flat-out wrong.  This
partially fixes the above and should make it possible for noobs to add
and remove interfaces without reading the entire source.

Signed-Off-By: Andy Lutomirski <luto@myrealbox.com>

------=_Part_18275_27558758.1198167005230
Content-Type: text/x-patch; name=iw_usability.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fafhsr1i0
Content-Disposition: attachment; filename=iw_usability.patch

ZGlmZiAtLWdpdCBhL2ludGVyZmFjZS5jIGIvaW50ZXJmYWNlLmMKaW5kZXggYjU0YTY2Yy4uZWZj
MmQ5MyAxMDA2NDQKLS0tIGEvaW50ZXJmYWNlLmMKKysrIGIvaW50ZXJmYWNlLmMKQEAgLTU1LDcg
KzU1LDcgQEAgc3RhdGljIGludCBnZXRfaWZfdHlwZShpbnQgKmFyZ2MsIGNoYXIgKioqYXJndiwg
ZW51bSBubDgwMjExX2lmdHlwZSAqdHlwZSkKIHN0YXRpYyBpbnQgaGFuZGxlX2ludGVyZmFjZV9h
ZGQoc3RydWN0IG5sODAyMTFfc3RhdGUgKnN0YXRlLAogCQkJCWNoYXIgKnBoeSwgY2hhciAqZGV2
LCBpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiB7Ci0JY2hhciAqbmFtZSA9IGFyZ3ZbMF07CisJY2hh
ciAqbmFtZTsKIAllbnVtIG5sODAyMTFfaWZ0eXBlIHR5cGU7CiAJaW50IHRwc2V0LCBlcnI7CiAJ
c3RydWN0IG5sX21zZyAqbXNnOwpAQCAtNjUsMTQgKzY1LDE1IEBAIHN0YXRpYyBpbnQgaGFuZGxl
X2ludGVyZmFjZV9hZGQoc3RydWN0IG5sODAyMTFfc3RhdGUgKnN0YXRlLAogCQlyZXR1cm4gLTE7
CiAJfQogCisJbmFtZSA9IGFyZ3ZbMF07CiAJYXJnYy0tOwogCWFyZ3YrKzsKIAotCWlmIChhcmdj
KSB7Ci0JCXRwc2V0ID0gZ2V0X2lmX3R5cGUoJmFyZ2MsICZhcmd2LCAmdHlwZSk7Ci0JCWlmICh0
cHNldCA8IDApCi0JCQlyZXR1cm4gLTE7Ci0JfQorCXRwc2V0ID0gZ2V0X2lmX3R5cGUoJmFyZ2Ms
ICZhcmd2LCAmdHlwZSk7CisJaWYgKHRwc2V0ID09IDApCisJCWZwcmludGYoc3RkZXJyLCAieW91
IG11c3Qgc3BlY2lmeSBhbiBpbnRlcmZhY2UgdHlwZVxuIik7CisJaWYgKHRwc2V0IDw9IDApCisJ
CXJldHVybiAtMTsKIAogCWlmIChhcmdjKSB7CiAJCWZwcmludGYoc3RkZXJyLCAidG9vIG1hbnkg
YXJndW1lbnRzXG4iKTsKQEAgLTE1MCw4ICsxNTEsMTAgQEAgaW50IGhhbmRsZV9pbnRlcmZhY2Uo
c3RydWN0IG5sODAyMTFfc3RhdGUgKnN0YXRlLAogewogCWNoYXIgKmNtZCA9IGFyZ3ZbMF07CiAK
LQlpZiAoYXJnYyA8IDEpCisJaWYgKGFyZ2MgPCAxKSB7CisJCWZwcmludGYoc3RkZXJyLCAieW91
IG11c3Qgc3BlY2lmeSBhbiBpbnRlcmZhY2UgY29tbWFuZFxuIik7CiAJCXJldHVybiAtMTsKKwl9
CiAKIAlhcmdjLS07CiAJYXJndisrOwpkaWZmIC0tZ2l0IGEvaXcuYyBiL2l3LmMKaW5kZXggYzJi
NTNlZS4uNDY5YmYwZSAxMDA2NDQKLS0tIGEvaXcuYworKysgYi9pdy5jCkBAIC05Miw4ICs5Miwx
MSBAQCBzdGF0aWMgaW50IGdldF9waHlfb3JfZGV2KGludCAqYXJnYywgY2hhciAqKiphcmd2LCBj
aGFyICoqbmFtZSkKIAogdm9pZCB1c2FnZShjaGFyICphcmd2MCkKIHsKLQlmcHJpbnRmKHN0ZGVy
ciwgIlVzYWdlOiAlcyBbb3B0aW9uc10ge2RldiA8cGh5ZGV2Pn0ge2ludGVyZmFjZSA8aW50ZXJm
YWNlPiB9IHtDT01NQU5EfVxuIgotCQkJIndoZXJlIENPTU1BTkQgOj0geyBhZGQgfCBkZWwgfVxu
IiwgYXJndjApOworCWZwcmludGYoc3RkZXJyLCAiVXNhZ2U6ICVzIGRldiA8cGh5ZGV2PiBpbnRl
cmZhY2UgPENPTU1BTkQ+IFtPUFRJT05TXVxuIgorCQkJIndoZXJlIENPTU1BTkQgOj0geyBhZGQg
fCBkZWwgfVxuIgorCQkJIlxuIgorCQkJIkZvciBhZGQsIE9QVElPTlMgOj0gPG5hbWU+IHR5cGUg
PHR5cGU+XG4iCisJCQkiRm9yIGRlbCwgT1BUSU9OUyBzaG91bGQgYmUgYmxhbmsgYW5kIHBoeWRl
diBpcyB0aGUgaW50ZXJmYWNlIHRvIGRlbGV0ZS5cbiIsIGFyZ3YwKTsKIH0KIAogaW50IG1haW4o
aW50IGFyZ2MsIGNoYXIgKiphcmd2KQo=
------=_Part_18275_27558758.1198167005230--
