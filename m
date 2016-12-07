Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:42410 "EHLO
        sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcLGKog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 05:44:36 -0500
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Laurent Trarieux <Laurent.Trarieux@ceva-dsp.com>
Subject: RE: [PATCH] mac80211: Ensure enough headroom when forwarding mesh pkt
Date: Wed, 7 Dec 2016 09:57:10 +0000
Message-ID: <39d4d6133bfb4302a69697b6b7946ce3@ceva-dsp.com> (sfid-20161207_114504_876743_149E89DF)
References: <356db1fcf788467f9145abc10e218d66@ceva-dsp.com>
         (sfid-20161206_134746_387190_5D33F815)
 <1481103603.4092.38.camel@sipsolutions.net>
In-Reply-To: <1481103603.4092.38.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+IC0JZndkX3NrYiA9IHNrYl9jb3B5KHNrYiwgR0ZQX0FUT01JQyk7DQo+ID4gKwlpZiAoc2ti
X2hlYWRyb29tKHNrYikgPj0gbG9jYWwtPnR4X2hlYWRyb29tKQ0KPiA+ICsJCWZ3ZF9za2IgPSBz
a2JfY29weShza2IsIEdGUF9BVE9NSUMpOw0KPiA+ICsJZWxzZQ0KPiA+ICsJCWZ3ZF9za2IgPSBz
a2JfY29weV9leHBhbmQoc2tiLCBsb2NhbC0+dHhfaGVhZHJvb20sDQo+ID4gKwkJCQkJwqDCoDAs
IEdGUF9BVE9NSUMpOw0KPiANCj4gV2h5IGJvdGhlciBtYWtpbmcgdGhpcyBjb25kaXRpb25hbD8g
SXQgc2VlbXMgdGhhdCBhbHdheXMgdXNpbmcNCj4gc2tiX2NvcHlfZXhwYW5kKCkgc2hvdWxkIGJl
IHN1ZmZpY2llbnQ/IFRoZSBjb2RlIGJldHdlZW4gdGhlIHR3byAoc2tiX2NvcHksDQo+IHNrYl9j
b3B5X2V4cGFuZCkgaXMgYWxtb3N0IGlkZW50aWNhbCBhbnl3YXksIGFwYXJ0IGZyb20gdGhlIGxh
dHRlciBzZXR0aW5nDQo+IHRoZSBoZWFkcm9vbSAoYW5kIHRhaWxyb29tKS4NCg0KSW5kZWVkLCBj
YWxsaW5nIHNrYl9jb3B5X2V4cGFuZCgpIHdvdWxkIHdvcmsgaW4gYW55IGNhc2UuDQpJIHdpbGwg
c2VuZCBuZXcgcGF0Y2gNCg0KY2VkcmljDQo=
