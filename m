Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60399 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965598Ab2EPURu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <1337162148-16499-1-git-send-email-ozancag@gmail.com>
References: <1337162148-16499-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 16 May 2012 13:17:28 -0700
Message-ID: <CAB=NE6W2dz=Ld=w5+7jexKk9xfADhk644mc4C=TtbvBZ9_cKGg@mail.gmail.com> (sfid-20120516_221756_209129_C0457267)
Subject: Re: [Lf_driver_backport] [PATCH] compat: backport ether_addr_equal
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2012 at 2:55 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> This backports:
>
>    commit a599b0f54d233d0f63d6be9a2ff0049d24751669
>    Author: Joe Perches <joe@perches.com>
>    Date:   Tue May 8 18:56:45 2012 +0000
>
>        etherdevice.h: Add ether_addr_equal
>
>        Add a boolean function to check if 2 ethernet addresses
>        are the same.
>
>        This is to avoid any confusion about compare_ether_addr
>        returning an unsigned, and not being able to use the
>        compare_ether_addr function for sorting ala memcmp.
>
>        Signed-off-by: Joe Perches <joe@perches.com>
>        Signed-off-by: David S. Miller <davem@davemloft.net>
>
> [root@ozzyfedora compat]# bin/ckmake
> Trying kernel                      3.3.4-5.fc17.x86_64  [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Thanks!! BTW I see this though:

Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

And then all I see is this when I save the e-mail to a txt file, given
that the encoding is base64. This is odd given that I see you sent
this with X-Mailer: git-send-email 1.7.10.1 -- so not sure how this
ended up going out like this.

This is what I see when I save the e-mail:

VGhpcyBiYWNrcG9ydHM6CgogICAgY29tbWl0IGE1OTliMGY1NGQyMzNkMGY2M2Q2YmU5YTJmZjAw
NDlkMjQ3NTE2NjkKICAgIEF1dGhvcjogSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4KICAg
IERhdGU6ICAgVHVlIE1heSA4IDE4OjU2OjQ1IDIwMTIgKzAwMDAKCiAgICAgICAgZXRoZXJkZXZp
Y2UuaDogQWRkIGV0aGVyX2FkZHJfZXF1YWwKCiAgICAgICAgQWRkIGEgYm9vbGVhbiBmdW5jdGlv
biB0byBjaGVjayBpZiAyIGV0aGVybmV0IGFkZHJlc3NlcwogICAgICAgIGFyZSB0aGUgc2FtZS4K
CiAgICAgICAgVGhpcyBpcyB0byBhdm9pZCBhbnkgY29uZnVzaW9uIGFib3V0IGNvbXBhcmVfZXRo
ZXJfYWRkcgogICAgICAgIHJldHVybmluZyBhbiB1bnNpZ25lZCwgYW5kIG5vdCBiZWluZyBhYmxl
IHRvIHVzZSB0aGUKICAgICAgICBjb21wYXJlX2V0aGVyX2FkZHIgZnVuY3Rpb24gZm9yIHNvcnRp
bmcgYWxhIG1lbWNtcC4KCiAgICAgICAgU2lnbmVkLW9mZi1ieTogSm9lIFBlcmNoZXMgPGpvZUBw
ZXJjaGVzLmNvbT4KICAgICAgICBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+Cgpbcm9vdEBvenp5ZmVkb3JhIGNvbXBhdF0jIGJpbi9ja21ha2UKVHJ5
aW5nIGtlcm5lbCAgICAgICAgICAgICAgICAgICAgICAzLjMuNC01LmZjMTcueDg2XzY0ICBbT0td
CgpTaWduZWQtb2ZmLWJ5OiBPemFuIMOHYcSfbGF5YW4gPG96YW5jYWdAZ21haWwuY29tPgotLS0K
IGluY2x1ZGUvbGludXgvY29tcGF0LTMuNS5oIHwgICAgNyArKysrKysrCiAxIGZpbGUgY2hhbmdl
ZCwgNyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jb21wYXQtMy41
LmggYi9pbmNsdWRlL2xpbnV4L2NvbXBhdC0zLjUuaAppbmRleCA1NTRkMzQ3Li5hODMyNjZiIDEw
MDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2NvbXBhdC0zLjUuaAorKysgYi9pbmNsdWRlL2xpbnV4
L2NvbXBhdC0zLjUuaApAQCAtMyw2ICszLDcgQEAKIAogI2luY2x1ZGUgPGxpbnV4L3ZlcnNpb24u
aD4KICNpbmNsdWRlIDxsaW51eC9mcy5oPgorI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+
CiAKICNpZiAoTElOVVhfVkVSU0lPTl9DT0RFIDwgS0VSTkVMX1ZFUlNJT04oMyw1LDApKQogCkBA
IC0xMiw2ICsxMywxMiBAQCBleHRlcm4gaW50IHNpbXBsZV9vcGVuKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIHN0cnVjdCBmaWxlICpmaWxlKTsKICNkZWZpbmUgdHR5X2xvY2soX190dHkpIHR0eV9sb2Nr
KCkKICNkZWZpbmUgdHR5X3VubG9jayhfX3R0eSkgdHR5X3VubG9jaygpCiAKKy8qIEJhY2twb3J0
IGV0aGVyX2FkZHJfZXF1YWwgKi8KK3N0YXRpYyBpbmxpbmUgYm9vbCBldGhlcl9hZGRyX2VxdWFs
KGNvbnN0IHU4ICphZGRyMSwgY29uc3QgdTggKmFkZHIyKQoreworICAgIHJldHVybiAhY29tcGFy
ZV9ldGhlcl9hZGRyKGFkZHIxLCBhZGRyMik7Cit9CisKICNlbmRpZiAvKiAoTElOVVhfVkVSU0lP
Tl9DT0RFIDwgS0VSTkVMX1ZFUlNJT04oMyw1LDApKSAqLwogCiAjZW5kaWYgLyogTElOVVhfM181
X0NPTVBBVF9IICovCi0tIAoxLjcuMTAuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGZfZHJpdmVyX2JhY2twb3J0IG1haWxpbmcgbGlzdApMZl9kcml2
ZXJfYmFja3BvcnRAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcKaHR0cHM6Ly9saXN0cy5saW51
eGZvdW5kYXRpb24ub3JnL21haWxtYW4vbGlzdGluZm8vbGZfZHJpdmVyX2JhY2twb3J0Cg==
