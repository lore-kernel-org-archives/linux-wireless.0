Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21100 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbdB1Exx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 23:53:53 -0500
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: Make pre-CAC results valid only for ETSI
 domain
Date: Tue, 28 Feb 2017 04:52:39 +0000
Message-ID: <58B501E2.80300@qti.qualcomm.com> (sfid-20170228_055409_777706_5CE3D369)
References: <1487587155-30487-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1487587155-30487-2-git-send-email-vthiagar@qti.qualcomm.com>
 <1488206288.28431.15.camel@sipsolutions.net>
In-Reply-To: <1488206288.28431.15.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uZGF5IDI3IEZlYnJ1YXJ5IDIwMTcgMDg6MDggUE0sIEpvaGFubmVzIEJlcmcgd3JvdGU6
DQo+IE9uIE1vbiwgMjAxNy0wMi0yMCBhdCAxNjowOSArMDUzMCwgVmFzYW50aGFrdW1hciBUaGlh
Z2FyYWphbiB3cm90ZToNCj4+IERGUyByZXF1aXJlbWVudCBmb3IgRVRTSSBkb21haW4gKHNlY3Rp
b24gNC43LjEuNCBpbg0KPj4gRVRTSSBFTiAzMDEgODkzIFYxLjguMSkgaXMgdGhlIG9ubHkgb25l
IHdoaWNoIGV4cGxpY2l0bHkNCj4+IHN0YXRlcyB0aGF0IG9uY2UgREZTIGNoYW5uZWwgaXMgbWFy
a2VkIGFzIGF2YWlsYWJsZSBhZmVyDQo+PiB0aGUgQ0FDLCB0aGlzIGNoYW5uZWwgd2lsbCByZW1h
aW4gaW4gYXZhaWxhYmxlIHN0YXRlIGV2ZW4NCj4+IG1vdmluZyB0byBhIGRpZmZlcmVudCBvcGVy
YXRpbmcgY2hhbm5lbC4gQnV0IHRoZSBzYW1lIGlzDQo+PiBub3QgZXhwbGljaXRseSBzdGF0ZWQg
aW4gRkNDIERGUyByZXF1aXJlbWVudC4gQWxzbywgUHJlLUNBQw0KPj4gcmVxdXJpZW1lbnRzIGFy
ZSBub3QgZXhwbGljaXRseSBtZW50aW9uZWQgaW4gRkNDIHJlcXVpcmVtZW50Lg0KPj4gQ3VycmVu
dCBpbXBsZW1lbnRhdGlvbiBpbiBrZWVwaW5nIERGUyBjaGFubmVsIGluIGF2YWlsYWJsZQ0KPj4g
c3RhdGUgaXMgc2FtZSBhcyBkZXNjcmliZWQgaW4gRVRTSSBkb21haW4uDQo+Pg0KPj4gRm9yIEVU
U0kgREZTIGRvbWFpbiwgdGhpcyBwYXRjaCBnaXZlcyBhIGdyYWNlIHBlcmlvZCBvZiAyIHNlY29u
ZHMNCj4NCj4gWW91IG1lYW4gbm9uLUVUU0ksIHJpZ2h0Pw0KDQpDb3JyZWN0LCBJIG1lYW50IG5v
bi1FVFNJLg0KDQo+DQo+IEp1c3QgbWFraW5nIHN1cmUgSSB1bmRlcnN0b29kIGNvcnJlY3RseSAt
IG5vIG5lZWQgdG8gcmVzZW5kLCBJIGNhbiBmaXgNCj4gdGhhdC4NCg0KVGhhbmtzIGZvciBwb2lu
dGluZyBpdCBvdXQgYW5kIGZpeGluZy4NCg0KVmFzYW50aA0K
