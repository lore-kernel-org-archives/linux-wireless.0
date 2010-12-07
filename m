Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f66.google.com ([209.85.216.66]:52300 "EHLO
	mail-qw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0LGWA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 17:00:56 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimhXLc-YkgPg9So71eOeOtDupnkGyZCEzvK6si3@mail.gmail.com>
References: <AANLkTimhXLc-YkgPg9So71eOeOtDupnkGyZCEzvK6si3@mail.gmail.com>
Date: Tue, 7 Dec 2010 23:00:55 +0100
Message-ID: <AANLkTik+NbXmX_kJtGJU-AvCE8qk37ExsQ=yTfFeVg6Z@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix modinfo does not list alias -> pci-id lines
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Bruno Randolf <br1@einfach.org>
Content-Type: multipart/mixed; boundary=00163646c1288c3fa50496d9235e
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--00163646c1288c3fa50496d9235e
Content-Type: text/plain; charset=UTF-8

On Tue, Dec 7, 2010 at 10:55 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> This patch fixes an issue in wirless-next-2.6 / linux-next
> (next-20101207) with ath5k and wrong modinfo output.
>
> - Sedat -
>

Argh, new attempt... Missing "Signed-off-by: ...".

- Sedat -

--00163646c1288c3fa50496d9235e
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-ath5k-Fix-modinfo-does-not-list-alias-pci-id-lines.patch"
Content-Disposition: attachment;
	filename="0001-ath5k-Fix-modinfo-does-not-list-alias-pci-id-lines.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghfc37rw1

RnJvbSBjMzIwODA2MzVhNTI1NDk2OTJlZDM2MTI2ZWMwYWViMjYxMWQwODE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDcgRGVjIDIwMTAgMjI6MzU6NTAgKzAxMDAKU3ViamVjdDogW1BBVENIXSBhdGg1
azogRml4IG1vZGluZm8gZG9lcyBub3QgbGlzdCBhbGlhcyAtPiBwY2ktaWQgbGluZXMKClRoZSBB
SEIgYnVzIHN1cHBvcnQgcGF0Y2hzZXQgbW92ZWQgdGhlIHRhYmxlICJLbm93biBQQ0kgaWRzIiBm
cm9tIGJhc2UuYwp0byBwY2kuYyAtIHVuZm9ydHVuYXRlbHksIE1PRFVMRV9ERVZJQ0VfVEFCTEUo
KSB3YXMgbm90IHRyYW5zZmVycmVkLgpXaXRoIHRoaXMgZml4ICdtb2RpbmZvIGF0aDVrJyBsaXN0
cyB0aGUgYWxpYXMgLT4gcGNpLWlkIGxpbmVzLCBhZ2Fpbi4KClRoZSBpc3N1ZSB3YXMgaW50cm9k
dWNlZCBieToKICAgY29tbWl0IGU1YjA0NmQ4NmZhYzYwOWY2MzZkMTI3YTM4ZGU5NGExNzVjN2U4
M2IKICAgImF0aDVrOiBNb3ZlIFBDSSBidXMgZnVuY3Rpb25zIHRvIHNlcGFyYXRlIGZpbGUuIgoK
U2lnbmVkLW9mZi1ieTogU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBk
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvcGNpLmMgfCAgICAxICsKIDEgZmlsZXMgY2hh
bmdlZCwgMSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9wY2kuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0
aC9hdGg1ay9wY2kuYwppbmRleCAzOWYwMzMxLi43ZjhjNWIwIDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoNWsvcGNpLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDVrL3BjaS5jCkBAIC00NSw2ICs0NSw3IEBAIHN0YXRpYyBERUZJTkVfUENJX0RFVklD
RV9UQUJMRShhdGg1a19wY2lfaWRfdGFibGUpID0gewogCXsgUENJX1ZERVZJQ0UoQVRIRVJPUywg
MHgwMDFkKSB9LCAvKiAyNDE3IE5hbGEgKi8KIAl7IDAgfQogfTsKK01PRFVMRV9ERVZJQ0VfVEFC
TEUocGNpLCBhdGg1a19wY2lfaWRfdGFibGUpOwogCiAvKiByZXR1cm4gYnVzIGNhY2hlc2l6ZSBp
biA0QiB3b3JkIHVuaXRzICovCiBzdGF0aWMgdm9pZCBhdGg1a19wY2lfcmVhZF9jYWNoZXNpemUo
c3RydWN0IGF0aF9jb21tb24gKmNvbW1vbiwgaW50ICpjc3opCi0tIAoxLjcuMi4zCgo=
--00163646c1288c3fa50496d9235e--
