Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49596 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaGME6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 00:58:11 -0400
Received: by mail-lb0-f181.google.com with SMTP id p9so1950929lbv.40
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 21:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALkVjQbmrypdzG9B2nQ1oCPGuzO2Va0_vcpvkQmdtOsWP2HHZA@mail.gmail.com>
References: <CALkVjQbNMNs__LsNG450fCpTNmAR3kfDFn2o7xxrdLjSi1wu=w@mail.gmail.com>
	<CALkVjQbmrypdzG9B2nQ1oCPGuzO2Va0_vcpvkQmdtOsWP2HHZA@mail.gmail.com>
Date: Sun, 13 Jul 2014 07:58:09 +0300
Message-ID: <CANUX_P0uf66J_k9FNV6AaJedq9PE==dHaOBsNXqc58T1L+qv1A@mail.gmail.com> (sfid-20140713_065815_213220_71BF122A)
Subject: Re: [iwlwifi] Wireless-AC 7260 disconnects every half and hour
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sascha Weaver <wzyboy@wzyboy.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e013d161e5b7cf404fe0c0597
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e013d161e5b7cf404fe0c0597
Content-Type: text/plain; charset=UTF-8

Hi,

On Fri, Jul 11, 2014 at 10:10 AM, Sascha Weaver <wzyboy@wzyboy.org> wrote:
> 2014-07-11 15:06 GMT+08:00 Sascha Weaver <wzyboy@wzyboy.org>:
>> I recently bought an Intel Wireless-AC 7260 (Dual band) to replace my
>> Intel Wireless-N 7260.
>
>
> Sorry, I forgot to include the kernel information:
>
> I am using Arch Linux with kernel 3.15.4. The firmware information is:
>
> filename: /lib/modules/3.15.4-1-ARCH/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko.gz
> license: GPL
> author: Copyright(c) 2003- 2014 Intel Corporation <ilw@linux.intel.com>
> version: in-tree:
> description: Intel(R) Wireless WiFi driver for Linux
> firmware: iwlwifi-100-5.ucode
> firmware: iwlwifi-1000-5.ucode
> firmware: iwlwifi-135-6.ucode
> firmware: iwlwifi-105-6.ucode
> firmware: iwlwifi-2030-6.ucode
> firmware: iwlwifi-2000-6.ucode
> firmware: iwlwifi-5150-2.ucode
> firmware: iwlwifi-5000-5.ucode
> firmware: iwlwifi-6000g2b-6.ucode
> firmware: iwlwifi-6000g2a-5.ucode
> firmware: iwlwifi-6050-5.ucode
> firmware: iwlwifi-6000-4.ucode
> firmware: iwlwifi-7265-8.ucode
> firmware: iwlwifi-3160-8.ucode
> firmware: iwlwifi-7260-8.ucode
> firmware: iwlwifi-8000-8.ucode
> srcversion: 8DF2F6932FD2B1941BD7397
>
>

Please try the patch attached.
Thanks

--089e013d161e5b7cf404fe0c0597
Content-Type: application/octet-stream;
	name="0001-Revert-mac80211-move-bufferable-MMPDU-check-to-fix-A.patch"
Content-Disposition: attachment;
	filename="0001-Revert-mac80211-move-bufferable-MMPDU-check-to-fix-A.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxjw5w8h0

RnJvbSA1ZjFkYzg4NWM0NzQwMzVlNzMxMjE3ODVmZTU1MzcyZjI1YzNlMDBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNv
bT4KRGF0ZTogTW9uLCA3IEp1bCAyMDE0IDEyOjAxOjExICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
UmV2ZXJ0ICJtYWM4MDIxMTogbW92ZSAiYnVmZmVyYWJsZSBNTVBEVSIgY2hlY2sgdG8gZml4IEFQ
CiBtb2RlIHNjYW4iCgpUaGlzIHJldmVydHMgY29tbWl0IDI3N2Q5MTZmYzJlOTU5YzNmMTA2OTA0
MTE2YmI0ZjdiMTE0OGQ0N2EgYXMgaXQgd2FzCmF0IGxlYXN0IGJyZWFraW5nIGl3bHdpZmkgYnkg
c2V0dGluZyB0aGUgSUVFRTgwMjExX1RYX0NUTF9OT19QU19CVUZGRVIKZmxhZyBpbiBhbGwga2lu
ZHMgb2YgaW50ZXJmYWNlIG1vZGVzLCBub3Qgb25seSBmb3IgQVAgbW9kZSB3aGVyZSBpdCBpcwph
cHByb3ByaWF0ZS4KClRvIGF2b2lkIHJlaW50cm9kdWNpbmcgdGhlIG9yaWdpbmFsIHByb2JsZW0s
IGV4cGxpY2l0bHkgY2hlY2sgZm9yIHByb2JlCnJlcXVlc3QgZnJhbWVzIGluIHRoZSBtdWx0aWNh
c3QgYnVmZmVyaW5nIGNvZGUuCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpGaXhlczogMjc3
ZDkxNmZjMmU5ICgibWFjODAyMTE6IG1vdmUgImJ1ZmZlcmFibGUgTU1QRFUiIGNoZWNrIHRvIGZp
eCBBUCBtb2RlIHNjYW4iKQpTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5i
ZXJnQGludGVsLmNvbT4KLS0tCiBuZXQvbWFjODAyMTEvdHguYyB8IDIwICsrKysrKysrKystLS0t
LS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3R4LmMgYi9uZXQvbWFjODAyMTEvdHguYwppbmRl
eCBkYTVkODY0Li4zZTA1ZTc2IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvdHguYworKysgYi9u
ZXQvbWFjODAyMTEvdHguYwpAQCAtNDE1LDYgKzQxNSw5IEBAIGllZWU4MDIxMV90eF9oX211bHRp
Y2FzdF9wc19idWYoc3RydWN0IGllZWU4MDIxMV90eF9kYXRhICp0eCkKIAlpZiAoaWVlZTgwMjEx
X2hhc19vcmRlcihoZHItPmZyYW1lX2NvbnRyb2wpKQogCQlyZXR1cm4gVFhfQ09OVElOVUU7CiAK
KwlpZiAoaWVlZTgwMjExX2lzX3Byb2JlX3JlcShoZHItPmZyYW1lX2NvbnRyb2wpKQorCQlyZXR1
cm4gVFhfQ09OVElOVUU7CisKIAlpZiAodHgtPmxvY2FsLT5ody5mbGFncyAmIElFRUU4MDIxMV9I
V19RVUVVRV9DT05UUk9MKQogCQlpbmZvLT5od19xdWV1ZSA9IHR4LT5zZGF0YS0+dmlmLmNhYl9x
dWV1ZTsKIApAQCAtNDY0LDYgKzQ2Nyw3IEBAIGllZWU4MDIxMV90eF9oX3VuaWNhc3RfcHNfYnVm
KHN0cnVjdCBpZWVlODAyMTFfdHhfZGF0YSAqdHgpCiB7CiAJc3RydWN0IHN0YV9pbmZvICpzdGEg
PSB0eC0+c3RhOwogCXN0cnVjdCBpZWVlODAyMTFfdHhfaW5mbyAqaW5mbyA9IElFRUU4MDIxMV9T
S0JfQ0IodHgtPnNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmhkciA9IChzdHJ1Y3QgaWVl
ZTgwMjExX2hkciAqKXR4LT5za2ItPmRhdGE7CiAJc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9j
YWwgPSB0eC0+bG9jYWw7CiAKIAlpZiAodW5saWtlbHkoIXN0YSkpCkBAIC00NzUsNiArNDc5LDEy
IEBAIGllZWU4MDIxMV90eF9oX3VuaWNhc3RfcHNfYnVmKHN0cnVjdCBpZWVlODAyMTFfdHhfZGF0
YSAqdHgpCiAJCSAgICAgIShpbmZvLT5mbGFncyAmIElFRUU4MDIxMV9UWF9DVExfTk9fUFNfQlVG
RkVSKSkpIHsKIAkJaW50IGFjID0gc2tiX2dldF9xdWV1ZV9tYXBwaW5nKHR4LT5za2IpOwogCisJ
CWlmIChpZWVlODAyMTFfaXNfbWdtdChoZHItPmZyYW1lX2NvbnRyb2wpICYmCisJCSAgICAhaWVl
ZTgwMjExX2lzX2J1ZmZlcmFibGVfbW1wZHUoaGRyLT5mcmFtZV9jb250cm9sKSkgeworCQkJaW5m
by0+ZmxhZ3MgfD0gSUVFRTgwMjExX1RYX0NUTF9OT19QU19CVUZGRVI7CisJCQlyZXR1cm4gVFhf
Q09OVElOVUU7CisJCX0KKwogCQlwc19kYmcoc3RhLT5zZGF0YSwgIlNUQSAlcE0gYWlkICVkOiBQ
UyBidWZmZXIgZm9yIEFDICVkXG4iLAogCQkgICAgICAgc3RhLT5zdGEuYWRkciwgc3RhLT5zdGEu
YWlkLCBhYyk7CiAJCWlmICh0eC0+bG9jYWwtPnRvdGFsX3BzX2J1ZmZlcmVkID49IFRPVEFMX01B
WF9UWF9CVUZGRVIpCkBAIC01MzQsMTkgKzU0NCw5IEBAIGllZWU4MDIxMV90eF9oX3VuaWNhc3Rf
cHNfYnVmKHN0cnVjdCBpZWVlODAyMTFfdHhfZGF0YSAqdHgpCiBzdGF0aWMgaWVlZTgwMjExX3R4
X3Jlc3VsdCBkZWJ1Z19ub2lubGluZQogaWVlZTgwMjExX3R4X2hfcHNfYnVmKHN0cnVjdCBpZWVl
ODAyMTFfdHhfZGF0YSAqdHgpCiB7Ci0Jc3RydWN0IGllZWU4MDIxMV90eF9pbmZvICppbmZvID0g
SUVFRTgwMjExX1NLQl9DQih0eC0+c2tiKTsKLQlzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyID0g
KHN0cnVjdCBpZWVlODAyMTFfaGRyICopdHgtPnNrYi0+ZGF0YTsKLQogCWlmICh1bmxpa2VseSh0
eC0+ZmxhZ3MgJiBJRUVFODAyMTFfVFhfUFNfQlVGRkVSRUQpKQogCQlyZXR1cm4gVFhfQ09OVElO
VUU7CiAKLQlpZiAoaWVlZTgwMjExX2lzX21nbXQoaGRyLT5mcmFtZV9jb250cm9sKSAmJgotCSAg
ICAhaWVlZTgwMjExX2lzX2J1ZmZlcmFibGVfbW1wZHUoaGRyLT5mcmFtZV9jb250cm9sKSkgewot
CQlpZiAodHgtPmZsYWdzICYgSUVFRTgwMjExX1RYX1VOSUNBU1QpCi0JCQlpbmZvLT5mbGFncyB8
PSBJRUVFODAyMTFfVFhfQ1RMX05PX1BTX0JVRkZFUjsKLQkJcmV0dXJuIFRYX0NPTlRJTlVFOwot
CX0KLQogCWlmICh0eC0+ZmxhZ3MgJiBJRUVFODAyMTFfVFhfVU5JQ0FTVCkKIAkJcmV0dXJuIGll
ZWU4MDIxMV90eF9oX3VuaWNhc3RfcHNfYnVmKHR4KTsKIAllbHNlCi0tIAoxLjguMS5tc3lzZ2l0
LjEKCg==
--089e013d161e5b7cf404fe0c0597--
