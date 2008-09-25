Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44576 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYIYRpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 13:45:03 -0400
Received: by gxk9 with SMTP id 9so7360161gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 10:45:01 -0700 (PDT)
Message-ID: <eb3ff54b0809251045m47949af5u6a1615f0d42d37a2@mail.gmail.com> (sfid-20080925_194509_651445_FA2C07D2)
Date: Thu, 25 Sep 2008 20:45:01 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: remove wme_tx_queue and wme_rx_queue from net/mac80211/sta_info.h
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_85930_26144388.1222364701455"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_85930_26144388.1222364701455
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
  This patch removes wme_tx_queue and wme_rx_queue from net/mac80211/sta_info.h
  as they are not used. (These variable names in fact a double declaration; one
  is a pointer to dentry struct (for DEBUGFS) and the second is an
array of ints
 (for Extra statistics for TX/RX debugging - when setting
 CONFIG_MAC80211_DEBUG_COUNTERS); both are not used.

	
Regards,
Rami Rosen
	
Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_85930_26144388.1222364701455
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fljo8jbk0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9zdGFfaW5mby5oIGIvbmV0L21hYzgwMjExL3N0YV9p
bmZvLmgKaW5kZXggMTA5ZGI3OC4uODFjMzM2OCAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3N0
YV9pbmZvLmgKKysrIGIvbmV0L21hYzgwMjExL3N0YV9pbmZvLmgKQEAgLTE5MSw3ICsxOTEsNiBA
QCBzdHJ1Y3Qgc3RhX2FtcGR1X21sbWUgewogICogQGxhc3RfcXVhbDogcXVhbCBvZiBsYXN0IHJl
Y2VpdmVkIGZyYW1lIGZyb20gdGhpcyBTVEEKICAqIEBsYXN0X25vaXNlOiBub2lzZSBvZiBsYXN0
IHJlY2VpdmVkIGZyYW1lIGZyb20gdGhpcyBTVEEKICAqIEBsYXN0X3NlcV9jdHJsOiBsYXN0IHJl
Y2VpdmVkIHNlcS9mcmFnIG51bWJlciBmcm9tIHRoaXMgU1RBIChwZXIgUlggcXVldWUpCi0gKiBA
d21lX3J4X3F1ZXVlOiBUQkQKICAqIEB0eF9maWx0ZXJlZF9jb3VudDogVEJECiAgKiBAdHhfcmV0
cnlfZmFpbGVkOiBUQkQKICAqIEB0eF9yZXRyeV9jb3VudDogVEJECkBAIC0yMDQsNyArMjAzLDYg
QEAgc3RydWN0IHN0YV9hbXBkdV9tbG1lIHsKICAqIEB0eF9mcmFnbWVudHM6IG51bWJlciBvZiB0
cmFuc21pdHRlZCBNUERVcwogICogQHR4cmF0ZV9pZHg6IFRCRAogICogQGxhc3RfdHhyYXRlX2lk
eDogVEJECi0gKiBAd21lX3R4X3F1ZXVlOiBUQkQKICAqIEBhbXBkdV9tbG1lOiBUQkQKICAqIEB0
aW1lcl90b190aWQ6IGlkZW50aXR5IG1hcHBpbmcgdG8gSUQgdGltZXJzCiAgKiBAdGlkX3RvX3R4
X3E6IG1hcCB0aWQgdG8gdHggcXVldWUKQEAgLTI2NSw5ICsyNjMsNiBAQCBzdHJ1Y3Qgc3RhX2lu
Zm8gewogCWludCBsYXN0X3F1YWw7CiAJaW50IGxhc3Rfbm9pc2U7CiAJX19sZTE2IGxhc3Rfc2Vx
X2N0cmxbTlVNX1JYX0RBVEFfUVVFVUVTXTsKLSNpZmRlZiBDT05GSUdfTUFDODAyMTFfREVCVUdf
Q09VTlRFUlMKLQl1bnNpZ25lZCBpbnQgd21lX3J4X3F1ZXVlW05VTV9SWF9EQVRBX1FVRVVFU107
Ci0jZW5kaWYKIAogCS8qIFVwZGF0ZWQgZnJvbSBUWCBzdGF0dXMgcGF0aCBvbmx5LCBubyBsb2Nr
aW5nIHJlcXVpcmVtZW50cyAqLwogCXVuc2lnbmVkIGxvbmcgdHhfZmlsdGVyZWRfY291bnQ7CkBA
IC0yODYsOSArMjgxLDYgQEAgc3RydWN0IHN0YV9pbmZvIHsKIAlpbnQgdHhyYXRlX2lkeDsKIAlp
bnQgbGFzdF90eHJhdGVfaWR4OwogCXUxNiB0aWRfc2VxW0lFRUU4MDIxMV9RT1NfQ1RMX1RJRF9N
QVNLICsgMV07Ci0jaWZkZWYgQ09ORklHX01BQzgwMjExX0RFQlVHX0NPVU5URVJTCi0JdW5zaWdu
ZWQgaW50IHdtZV90eF9xdWV1ZVtOVU1fUlhfREFUQV9RVUVVRVNdOwotI2VuZGlmCiAKIAkvKgog
CSAqIEFnZ3JlZ2F0aW9uIGluZm9ybWF0aW9uLCBsb2NrZWQgd2l0aCBsb2NrLgpAQCAtMzE5LDEw
ICszMTEsNiBAQCBzdHJ1Y3Qgc3RhX2luZm8gewogCQlzdHJ1Y3QgZGVudHJ5ICpudW1fcHNfYnVm
X2ZyYW1lczsKIAkJc3RydWN0IGRlbnRyeSAqaW5hY3RpdmVfbXM7CiAJCXN0cnVjdCBkZW50cnkg
Kmxhc3Rfc2VxX2N0cmw7Ci0jaWZkZWYgQ09ORklHX01BQzgwMjExX0RFQlVHX0NPVU5URVJTCi0J
CXN0cnVjdCBkZW50cnkgKndtZV9yeF9xdWV1ZTsKLQkJc3RydWN0IGRlbnRyeSAqd21lX3R4X3F1
ZXVlOwotI2VuZGlmCiAJCXN0cnVjdCBkZW50cnkgKmFnZ19zdGF0dXM7CiAJfSBkZWJ1Z2ZzOwog
I2VuZGlmCg==
------=_Part_85930_26144388.1222364701455--
