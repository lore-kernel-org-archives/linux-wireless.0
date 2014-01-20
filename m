Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54763 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaATIIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 03:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <52DC3AF7.4060606@hauke-m.de>
References: <52DC3AF7.4060606@hauke-m.de>
Date: Mon, 20 Jan 2014 10:08:15 +0200
Message-ID: <CANUX_P3UNX9ygW6smT8HhUCqQfDvChnMHMKOq2FvMZ9WX077OA@mail.gmail.com> (sfid-20140120_090821_058220_BFD71862)
Subject: Re: kernel freezes when insmoding iwldvm.ko from backports-20140117
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: multipart/mixed; boundary=089e01176b29d4204704f06264d0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e01176b29d4204704f06264d0
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jan 19, 2014 at 10:52 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Hi,
>
> when I insmoding iwldvm.ko from backports-201400117 my kernel freezes
> and does not show any error message. This problem started with
> backports-20140106, backports-20131224 works for me.
>
> I am using the Ubuntu kernel 3.5.0-45 someone else with the same problem
> uses kernel 3.2.0. I am using a Intel 6300.
> Someone reported that an Atheros card worked, so this is probably a
> problem in iwlwifi.
>

patch attached

--089e01176b29d4204704f06264d0
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-iwlwifi-pcie-don-t-panic-on-host-commands-in-iwldvm.patch"
Content-Disposition: attachment;
	filename="0001-iwlwifi-pcie-don-t-panic-on-host-commands-in-iwldvm.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqng9ynd0

RnJvbSAyODFlNmJlZGRmM2Q0NjY2MWI2YzFkZDdhNGRlZGZkZTc4YmRmNmVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBNb24sIDIwIEphbiAyMDE0IDA5OjUwOjI5ICswMjAwClN1YmplY3Q6
IFtQQVRDSF0gaXdsd2lmaTogcGNpZTogZG9uJ3QgcGFuaWMgb24gaG9zdCBjb21tYW5kcyBpbiBp
d2xkdm0KCk15IGNvbW1pdDoKCk5vbmUgb2YgdGhlIGRldmljZXMgc3VwcG9ydGVkIGJ5IGl3bGR2
bSBoYXZlIHN1cHBvcnQgZm9yCnNoYWRvdyByZWdpc3RlcnMuIFRoaXMgbWVhbnMgdGhhdCB3ZSB3
YWtlIHRoZSBOSUMgd2hlbiB3ZQpzZW5kIGhvc3QgY29tbWFuZHMgd2hlbiB3ZSBpbmNyZW1lbnQg
dGhlIHdyaXRlIHBvaW50ZXIgb24KdGhlIGhvc3QgY29tbWFuZHMgcmluZy4gVGhpcyBoYXBwZW5l
ZCBldmVuIGJlZm9yZSBteSBiYWQKY29tbWl0IG1lbnRpb25uZWQgYmVsb3cuClNpbmNlIG15IGNv
bW1pdCBiZWxvdywgd2Ugd2FrZSB1cCB0aGUgTklDIHJlZ2FyZGxlc3Mgb2YKc2hhZG93IHJlZ2lz
dGVyIHN1cHBvcnQuIFRoaXMgbWVhbnMgdGhhdCBpbiBpd2xkdm0gKHdoZW4KdGhlIE5JQyBkb2Vz
bid0IHN1cHBvcnQgc2hhZG93IHJlZ2lzdGVyKSwgd2Ugd2FrZSB1cCB0aGUKTklDIHR3aWNlOgoK
cGNpZV9lbnF1ZXVlX2hjbWQ6Cgl3YWtlIHVwIHRoZSBOSUMKCWl3bF9wY2llX3R4cV9pbmNfd3Jf
cHRyOgoJCXdha2UgdXAgdGhlIE5JQyAtIG5vIHNoYWRvdyByZWcgc3VwcG9ydAoKU2luY2Ugd2Fr
aW5nIHVwIHRoZSBOSUMgbWVhbnMgdGhhdCB3ZSBuZWVkIHRvIGEgc3BpbmxvY2ssCnRoaXMgb2J2
aW91c2x5IGxlYWRzIHRvIGEgcmVjdXJzaXZlIHNwaW5sb2NrIGFuZCBoZW5jZSBhCmZyZWV6ZS4K
CkZpeGVzOiBiOTQzOTQ5MTA1NWEgKCJpd2x3aWZpOiBwY2llOiBrZWVwIHRoZSBOSUMgYXdha2Ug
d2hlbiBjb21tYW5kcyBhcmUgaW4gZmxpZ2h0IikKUmVwb3J0ZWQtYnk6IEphbnVzeiBEemllZHpp
YyA8amFudXN6LmR6aWVkemljQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogRW1tYW51ZWwgR3J1
bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJl
bGVzcy9pd2x3aWZpL3BjaWUvdHguYyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9wY2llL3R4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL3BjaWUvdHgu
YwppbmRleCAyNzA1MDllLi4wYjFhOTNlIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9pd2x3aWZpL3BjaWUvdHguYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL3Bj
aWUvdHguYwpAQCAtMjk0LDEzICsyOTQsMTQgQEAgc3RhdGljIHZvaWQgaXdsX3BjaWVfdHhxX2lu
dmFsX2J5dGVfY250X3RibChzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucywKICAqLwogdm9pZCBpd2xf
cGNpZV90eHFfaW5jX3dyX3B0cihzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucywgc3RydWN0IGl3bF90
eHEgKnR4cSkKIHsKKwlzdHJ1Y3QgaXdsX3RyYW5zX3BjaWUgKnRyYW5zX3BjaWUgPSBJV0xfVFJB
TlNfR0VUX1BDSUVfVFJBTlModHJhbnMpOwogCXUzMiByZWcgPSAwOwogCWludCB0eHFfaWQgPSB0
eHEtPnEuaWQ7CiAKIAlpZiAodHhxLT5uZWVkX3VwZGF0ZSA9PSAwKQogCQlyZXR1cm47CiAKLQlp
ZiAodHJhbnMtPmNmZy0+YmFzZV9wYXJhbXMtPnNoYWRvd19yZWdfZW5hYmxlKSB7CisJaWYgKHRy
YW5zLT5jZmctPmJhc2VfcGFyYW1zLT5zaGFkb3dfcmVnX2VuYWJsZSB8fCB0eHFfaWQgPT0gdHJh
bnNfcGNpZS0+Y21kX3F1ZXVlKSB7CiAJCS8qIHNoYWRvdyByZWdpc3RlciBlbmFibGVkICovCiAJ
CWl3bF93cml0ZTMyKHRyYW5zLCBIQlVTX1RBUkdfV1JQVFIsCiAJCQkgICAgdHhxLT5xLndyaXRl
X3B0ciB8ICh0eHFfaWQgPDwgOCkpOwotLSAKMS44LjMuMgoK
--089e01176b29d4204704f06264d0--
