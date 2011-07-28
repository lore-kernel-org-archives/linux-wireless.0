Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64494 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab1G1RNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:13:04 -0400
Received: by qwk3 with SMTP id 3so1451203qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 10:13:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E31975D.2000804@gnu.org>
References: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com>
 <1311722362-4070-5-git-send-email-lrodriguez@qca.qualcomm.com> <4E31975D.2000804@gnu.org>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Thu, 28 Jul 2011 10:12:43 -0700
Message-ID: <CAB=NE6V2mR76W4JRqOv=+UUkq=J7D2WsH1qDOLQ4mcQ+t7KvnA@mail.gmail.com> (sfid-20110728_191308_595927_8D9A37ED)
Subject: Re: [PATCH v5 4/4] hostapd: add Automatic Channel Selection (ACS) support
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	jouni@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCBKdWwgMjgsIDIwMTEgYXQgMTA6MDcgQU0sIFBhdmVsIFJvc2tpbiA8cHJvc2tpQGdu
dS5vcmc+IHdyb3RlOgo+IE9uIDA3LzI2LzIwMTEgMDc6MTkgUE0sIEx1aXMgUi4gUm9kcmlndWV6
IHdyb3RlOgo+PiBAQCAtMTczNiw3ICsxNzM2LDE4IEBAIHN0cnVjdCBob3N0YXBkX2NvbmZpZyAq
IGhvc3RhcGRfY29uZmlnX3JlYWQoY29uc3QgY2hhciAqZm5hbWUpCj4+IMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGVycm9ycysrOwo+PiDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCB9Cj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIH0gZWxzZSBpZiAo
b3Nfc3RyY21wKGJ1ZiwgImNoYW5uZWwiKSA9PSAwKSB7Cj4+IC0gwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgY29uZi0+Y2hhbm5lbCA9IGF0b2kocG9zKTsKPj4gKyDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBpZiAob3Nfc3RyY21wKHBvcywgImFjc19zdXJ2ZXkiKSA9PSAwKSB7
Cj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZi0+Y2hh
bm5lbCA9IDA7Cj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfSBlbHNlCj4+ICsg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZi0+Y2hhbm5lbCA9
IGF0b2kocG9zKTsKPgo+IEl0IHdvdWxkIGJlIG5pY2UgdG8gZW5hYmxlIEFDUyBhbHNvIGlmICJj
aGFubmVsIiBpcyBub3Qgc2V0IGF0IGFsbC4gwqBJdAo+IG1heSBsb29rIHN0cmFuZ2UgZnJvbSB0
aGUgcG9pbnQgb2YgdmlldyBvZiB0aGUgY29kZSBhdXRob3JzLiDCoEhvd2V2ZXIsCj4gaXQgbWFr
ZXMgc2Vuc2UgZnJvbSB0aGUgcG9pbnQgb2YgdmlldyBvZiB0aGUgZW5kIHVzZXIuIMKgSWYgc29t
ZXRoaW5nIGlzCj4gbm90IHNwZWNpZmllZCwgdGhlIGRyaXZlciBzaG91bGQgYmUgYWJsZSB0byBt
YWtlIGEgcmVhc29uYWJsZSBjaG9pY2UgYnkKPiBpdHNlbGYuCgpTdXJlLCBwYXRjaCB3ZWxjb21l
ZC4KCiBMdWlzCg==
