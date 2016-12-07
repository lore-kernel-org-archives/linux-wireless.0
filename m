Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60673 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbcLGJdQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:33:16 -0500
From: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
Date: Wed, 7 Dec 2016 09:33:08 +0000
Message-ID: <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com> (sfid-20161207_103322_763401_E9B783AD)
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
         <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
 <1481102727.4092.34.camel@sipsolutions.net>
In-Reply-To: <1481102727.4092.34.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWls
dG86am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldF0NCg0KPiBXaGF0IGFib3V0IEFyZW5kJ3MgY29t
bWVudCByZWdhcmRpbmcgdGhpcyBmdW5jdGlvbmFsaXR5IG92ZXJsYXBwaW5nIHdpdGggdGhlDQo+
IEJTUyBzZWxlY3Rpb24gb2ZmbG9hZCBjb25maWd1cmF0aW9uPw0KPiANCj4gRG8geW91IHRoaW5r
IHRoZXJlJ3MgYW55IGFiaWxpdHkgdG8gc2hhcmUgYXR0cmlidXRlcy9mdW5jdGlvbmFsaXR5Pw0K
DQpIaSBKb2hhbm5lcywNCg0KSSB0aGluayB0aGUgbGF0ZXIgY29tbWVudCBmcm9tIEx1Y2Egb24g
dGhpcyB3aGljaCBJIHBhc3RlZCBiZWxvdyBpcyBtb3JlIGFncmVlYWJsZS4NCg0KWWVzLCBzaW1p
bGFyIGJ1dCBub3QgcXVpdGUgdGhlIHNhbWUuICBUaGUgZXhpc3RpbmcgY2FzZSBpcyBmb3IgZmlu
ZGluZyBCU1NzIHRoYXQgYXJlIHdvcnRoIHdha2luZyB0aGUgaG9zdCB1cCBmb3IgKHdoaWxlIGRp
c2Nvbm5lY3RlZCksIHNvIGl0IG5lZWRzIHRvIGJlIGJldHRlciB0aGFuIHRoZSBSU1NJIHBhc3Nl
ZCAoYWJzb2x1dGUgbnVtYmVyKS4gIE5vdyB0aGlzIGlzIGFib3V0IHJlbGF0aXZlIFJTU0kgYXMg
Y29tcGFyZWQgdG8gdGhlIGN1cnJlbnQgY29ubmVjdGlvbiwgc28gUkVMQVRJVkVfUlNTSSBpcyBk
aWZmZXJlbnQgdGhhbiBSU1NJIGFuZCBJIHRoaW5rIHRoZSBzYW1lIGF0dHJpYnV0ZSBzaG91bGQg
bm90IGJlIHVzZWQsIHRvIGF2b2lkIGNvbmZ1c2lvbi4NCg0KVGhhbmtzLA0KVmFtc2kNCg==
