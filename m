Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16738 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdDRMIY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 08:08:24 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH V2 3/3] cfg80211: Share Channel DFS state across wiphys of
 same DFS domain
Date: Tue, 18 Apr 2017 12:08:00 +0000
Message-ID: <58F6019A.1060401@qti.qualcomm.com> (sfid-20170418_140827_764023_576E6EDD)
References: <1488195275-29371-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1488195275-29371-4-git-send-email-vthiagar@qti.qualcomm.com>
 <1492512604.2472.20.camel@sipsolutions.net>
In-Reply-To: <1492512604.2472.20.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlc2RheSAxOCBBcHJpbCAyMDE3IDA0OjIwIFBNLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
Pg0KPj4gK3ZvaWQgcmVndWxhdG9yeV9wcm9wYWdhdGVfZGZzX3N0YXRlKHN0cnVjdCB3aXBoeSAq
d2lwaHksDQo+PiArCQkJCSAgICBzdHJ1Y3QgY2ZnODAyMTFfY2hhbl9kZWYNCj4+ICpjaGFuZGVm
LA0KPj4gKwkJCQkgICAgZW51bSBubDgwMjExX2Rmc19zdGF0ZQ0KPj4gZGZzX3N0YXRlLA0KPj4g
KwkJCQkgICAgZW51bSBubDgwMjExX3JhZGFyX2V2ZW50IGV2ZW50KQ0KPj4gK3sNCj4+ICsJc3Ry
dWN0IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNlICpyZGV2Ow0KPj4gKw0KPj4gKwlBU1NFUlRf
UlROTCgpOw0KPj4gKw0KPj4gKwlpZiAoV0FSTl9PTighY2ZnODAyMTFfY2hhbmRlZl92YWxpZChj
aGFuZGVmKSkpDQo+PiArCQlyZXR1cm47DQo+PiArDQo+PiArCWlmIChXQVJOX09OKCEoY2hhbmRl
Zi0+Y2hhbi0+ZmxhZ3MgJiBJRUVFODAyMTFfQ0hBTl9SQURBUikpKQ0KPj4gKwkJcmV0dXJuOw0K
Pg0KPg0KPiBUaGlzIHdhcm4gb24gcmVsaWFibHkgdHJpZ2dlcnMgZm9yIG1lIHdoZW4gSSBydW4g
dGhlICJhcF92aHQxNjAiIGh3c2ltDQo+IHRlc3QgZnJvbSB3cGFfc3VwcGxpY2FudC4NCj4NCj4g
SSB0aGluayB0aGVyZSBtaWdodCBiZSBzb21lIGNvbmZ1c2lvbiBhYm91dCB0aGlzIHdoZW4gcGFy
dHMgb2YgdGhlIDE2MA0KPiBNSHogY2hhbm5lbCByZXF1aXJlIHJhZGFyIGFuZCBwYXJ0cyBkb24n
dD8gQnV0IEkgaGF2ZW4ndCBsb29rZWQgaW50bw0KPiB0aGlzIGF0IGFsbC4NCg0KQ29ycmVjdCwg
d2hlbiBzb21lIHBhcnQgb2YgYSBiaWdnZXIgYmFuZHdpZHRoIGNoYW5uZWwgZmFsbHMgaW4gREZT
IGNoYW5uZWwgcmFuZ2UNCmNoYW5uZWwgZGVmaW5pdGlvbiBvZiB0aGF0IGNoYW5uZWwncyBjZW50
ZXIgZnJlcSBpcyBtYXkgbm90IGJlIGEgcmFkYXIgY2hhbm5lbCBhbmQNCmJhaWxpbmcgb3V0IGJh
c2VkIG9uIHRoZSBjaGFubmVsIGZsYWcgdGhlcmUgaXMgbm90IHJpZ2h0Lg0KDQpTb3JyeSBmb3Ig
dGhlIGJ1ZyBhbmQgdGhhbmtzIGZvciByZXBvcnRpbmcgaXQuDQoNCj4NCj4gUGxlYXNlIHNlbmQg
bWUgYSBmaXggQVNBUCBzbyBKb3VuaSBkb2Vzbid0IHNob3V0IGF0IG1lIGZvciB0ZXN0DQo+IGZh
aWx1cmVzIDopDQoNClN1cmUuDQoNClZhc2FudGg=
