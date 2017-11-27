Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:37420 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbdK0TOS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 14:14:18 -0500
From: Peng Xu <pxu@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sara Sharon" <sara.sharon@intel.com>
Subject: RE: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
Date: Mon, 27 Nov 2017 19:14:15 +0000
Message-ID: <15034b29555b487bb172735015f5b78f@nasanexm01a.na.qualcomm.com> (sfid-20171127_201423_085022_FA8A0A69)
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
         <1510664296.2030.22.camel@sipsolutions.net>
         <4927d2288442486788cd5b4d0492537a@NASANEXM01F.na.qualcomm.com>
         <1510669408.2030.23.camel@sipsolutions.net>
         <929d1fdb74524aeaab4959f84a82c732@NASANEXM01F.na.qualcomm.com>
         <1510669995.2030.26.camel@sipsolutions.net>
         <e540b35f76a447cab35f7267c09ee8f5@NASANEXM01F.na.qualcomm.com>
         <20171114163127.GA24453@jouni.qca.qualcomm.com>
         <59a37842482b40ceb5e60c2155bca78c@NASANEXM01F.na.qualcomm.com>
 <1511784190.5456.13.camel@sipsolutions.net>
In-Reply-To: <1511784190.5456.13.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBJcyBhIG5ldyB2ZXJzaW9uIG9mIHRoaXMgcGF0Y2ggaGluZ2luZyBvbmx5IG9uIHRoaXM/IFdl
J2QgbG92ZSB0byBoYXZlIGEgZml4ZWQtDQo+IHVwIG9uZSA6LSkNCg0KVGhlIG5ldyB2ZXJzaW9u
IGNvdmVycyB0aGUgdXNlIGNhc2VzIG1lbnRpb25lZCBieSBKb3VuaSBhcyB0aGUgT1VJcyBvZiB0
aGUgdmVuZG9yIGNvbW1hbmRzIA0KaGFzIHRoZSBmb3JtYXQgb2YgT1VJICsgdHlwZSArIHN1YnR5
cGUuIEZvciBvdGhlciBmb3JtYXQgb2YgdmVuZG9yIGNvbW1hbmRzLCB0aGV5IHdpbGwgYmUgdHJl
YXRlZA0KYXMgZGlmZmVyZW50IHZlbmRvciBjb21tYW5kcyBhbmQgYXJlIGFkZGVkIGluIHRoZSBu
ZXcgSUUgYXMgd2VsbC4gDQoNCkpvdW5pLCBjb3VsZCB5b3UgY2hpbWUgaW4gdG8gZXhwbGFpbiB5
b3VyIHZpZXcgb24gdGhpcz8NCg0KVGhhbmtzLA0KUGVuZw0K
