Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49767 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbaLWMD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 07:03:26 -0500
Message-ID: <1419335948.29925.33.camel@gmx.de> (sfid-20141223_130330_244333_A283E10B)
Subject: [PATCH] iw dev link: print channel number as well
From: Recursive Madman <recursive.madman@gmx.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Dec 2014 12:59:08 +0100
Content-Type: multipart/mixed; boundary="=-ybxQGyN2QnVzfBEJlUGe"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ybxQGyN2QnVzfBEJlUGe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,
  dev <devname> link
prints the SSID and frequency, when connected.
To figure out the channel however (if you don't
know it by heart), you need to use
  dev <devname> info
which will print the channel along with the
frequency (though not the current SSID).

With attached patch,
  dev <devname> link
prints the channel along with the frequency, e.g. as:
	freq: 2442
	channel: 7
.

I find it more convenient this way.

-- madman.

--=-ybxQGyN2QnVzfBEJlUGe
Content-Disposition: attachment; filename="0001-dev-link-print-channel-number-as-well.patch"
Content-Type: text/x-patch; name="0001-dev-link-print-channel-number-as-well.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAwZTE2NzAxOGZiYzk1NTgwYmEyY2I5NDEyODQ1MmExODQ2M2NiZGUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSZWN1cnNpdmUgTWFkbWFuIDxyZWN1cnNpdmUubWFkbWFuQGdt
eC5kZT4KRGF0ZTogTW9uLCAyMiBEZWMgMjAxNCAxNToyMTowNyArMDEwMApTdWJqZWN0OiBbUEFU
Q0hdIGRldiBsaW5rOiBwcmludCBjaGFubmVsIG51bWJlciBhcyB3ZWxsCgpTaWduZWQtb2ZmLWJ5
OiBSZWN1cnNpdmUgTWFkbWFuIDxyZWN1cnNpdmUubWFkbWFuQGdteC5kZT4KLS0tCiBsaW5rLmMg
fCA1ICsrKystCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvbGluay5jIGIvbGluay5jCmluZGV4IGY3ODE4ZjUuLjYyOWIyYmEgMTAw
NjQ0Ci0tLSBhL2xpbmsuYworKysgYi9saW5rLmMKQEAgLTg0LDkgKzg0LDEyIEBAIHN0YXRpYyBp
bnQgbGlua19ic3NfaGFuZGxlcihzdHJ1Y3QgbmxfbXNnICptc2csIHZvaWQgKmFyZykKIAkJCSAg
bmxhX2xlbihic3NbTkw4MDIxMV9CU1NfSU5GT1JNQVRJT05fRUxFTUVOVFNdKSwKIAkJCSAgZmFs
c2UsIFBSSU5UX0xJTkspOwogCi0JaWYgKGJzc1tOTDgwMjExX0JTU19GUkVRVUVOQ1ldKQorCWlm
IChic3NbTkw4MDIxMV9CU1NfRlJFUVVFTkNZXSkgewogCQlwcmludGYoIlx0ZnJlcTogJWRcbiIs
CiAJCQlubGFfZ2V0X3UzMihic3NbTkw4MDIxMV9CU1NfRlJFUVVFTkNZXSkpOworCQlwcmludGYo
Ilx0Y2hhbm5lbDogJWRcbiIsCisgICAgICAgICAgIGllZWU4MDIxMV9mcmVxdWVuY3lfdG9fY2hh
bm5lbChubGFfZ2V0X3UzMihic3NbTkw4MDIxMV9CU1NfRlJFUVVFTkNZXSkpKTsKKyAgfQogCiAJ
aWYgKG5sYV9nZXRfdTMyKGJzc1tOTDgwMjExX0JTU19TVEFUVVNdKSAhPSBOTDgwMjExX0JTU19T
VEFUVVNfQVNTT0NJQVRFRCkKIAkJcmV0dXJuIE5MX1NLSVA7Ci0tIAoyLjEuMwoK


--=-ybxQGyN2QnVzfBEJlUGe--

