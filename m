Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:54019 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966427AbZLHWoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:44:03 -0500
Message-ID: <4B1ED6B9.3000005@gmail.com>
Date: Tue, 08 Dec 2009 23:44:09 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Andi Kleen <andi@firstfloor.org>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in  	2.6.32
References: <20091204233202.GA13658@basil.fritz.box>	 <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>	 <4B1EC842.7040407@gmail.com>  <200912082339.16893.s.L-H@gmx.de> <1260312016.32227.6.camel@johannes.local>
In-Reply-To: <1260312016.32227.6.camel@johannes.local>
Content-Type: multipart/mixed;
 boundary="------------090200010405020800020401"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090200010405020800020401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/08/09 23:40, Johannes Berg wrote:
> On Tue, 2009-12-08 at 23:39 +0100, Stefan Lippers-Hollmann wrote:
> 
>> Unfortunately this fails to compile for me:
> 
> well remove the spurious opening brace? :)
> 

Correct. That will teach me to make last minute edits without recompiling :-(

Corrected patch attached.

---
Gertjan.


--------------090200010405020800020401
Content-Type: text/plain;
 name="2.6.32-powersave-fix.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="2.6.32-powersave-fix.diff"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDYxcGNpLmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQ2MXBjaS5jCmluZGV4IDY4N2UxN2QuLjc3
YjI1NzUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDYxcGNp
LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0NjFwY2kuYwpAQCAtOTQ3
LDkgKzk0NywxNyBAQCBzdGF0aWMgdm9pZCBydDYxcGNpX2NvbmZpZ19wcyhzdHJ1Y3QgcnQy
eDAwX2RldiAqcnQyeDAwZGV2LAogCWVudW0gZGV2X3N0YXRlIHN0YXRlID0KIAkgICAgKGxp
YmNvbmYtPmNvbmYtPmZsYWdzICYgSUVFRTgwMjExX0NPTkZfUFMpID8KIAkJU1RBVEVfU0xF
RVAgOiBTVEFURV9BV0FLRTsKKwlzdHJ1Y3QgZGF0YV9xdWV1ZSAqcXVldWU7CiAJdTMyIHJl
ZzsKIAogCWlmIChzdGF0ZSA9PSBTVEFURV9TTEVFUCkgeworCQkvKgorCQkgKiBEb24ndCBn
byB0byBzbGVlcCB3aGVuIHRoZSBUWCBxdWV1ZXMgYXJlbid0IGVtcHR5LgorCQkgKi8KKwkJ
dHhfcXVldWVfZm9yX2VhY2gocnQyeDAwZGV2LCBxdWV1ZSkKKwkJCWlmICghcnQyeDAwcXVl
dWVfZW1wdHkocXVldWUpKQorCQkJCXJldHVybjsKKwogCQlydDJ4MDBwY2lfcmVnaXN0ZXJf
cmVhZChydDJ4MDBkZXYsIE1BQ19DU1IxMSwgJnJlZyk7CiAJCXJ0MngwMF9zZXRfZmllbGQz
MigmcmVnLCBNQUNfQ1NSMTFfREVMQVlfQUZURVJfVEJDTiwKIAkJCQkgICBydDJ4MDBkZXYt
PmJlYWNvbl9pbnQgLSAxMCk7Cg==
--------------090200010405020800020401--
