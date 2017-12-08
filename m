Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5418 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbdLHJWa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 04:22:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: Rob Herring <robh@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ext.waldemar.rymarkiewicz@tieto.com"
        <ext.waldemar.rymarkiewicz@tieto.com>
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry for ath10k calibration
 variant
Date: Fri, 8 Dec 2017 09:22:24 +0000
Message-ID: <87k1xxtvzk.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_102242_494774_8E50A91C)
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
        <5158144.BXJK97egUR@bentobox>
        <CAL_JsqKSBA8WcR9Q8+6+kVfYoPggZ83yQ_47LWf971Aegqv4yA@mail.gmail.com>
        <5711518.JB9VTipMpE@bentobox>
In-Reply-To: <5711518.JB9VTipMpE@bentobox> (Sven Eckelmann's message of "Wed,
        22 Mar 2017 08:20:25 +0100")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNCmdldHRpbmcgYmFjayB0byB0aGlzIG9sZCB0aHJlYWQsIGhlcmUncyB0aGUgZGlzY3Vz
c2lvbjoNCg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC85NjE1MTgzLw0KDQpo
dHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzk2MTUxODUvDQoNClN2ZW4gRWNrZWxt
YW5uIDxzdmVuLmVja2VsbWFubkBvcGVubWVzaC5jb20+IHdyaXRlczoNCg0KPiBPbiBEaWVuc3Rh
ZywgMjEuIE3DpHJ6IDIwMTcgMjE6NTY6NTQgQ0VUIFJvYiBIZXJyaW5nIHdyb3RlOg0KPiBbLi4u
XQ0KPj4gSXMgdGhpcyBhbHdheXMgdGhlIGNhc2U/IFRoZXJlJ3MgbmV2ZXIgc29tZSB2YXJpYXRp
b24gYmV5b25kIHRoZQ0KPj4gcmVmZXJlbmNlIGRlc2lnbiB0aGF0IGEgQkRGIGRpZmZlcmVuY2Ug
Y2FuJ3QgaGFuZGxlPw0KPg0KPiBJIGhhdmUgbm8ga25vd2xlZGdlIGFib3V0IGFueXRoaW5nIHdo
aWNoIGlzbid0IGhhbmRsZWQgZGlyZWN0bHkgYnkgdGhlIEJERg0KPiB2YXJpYW50cy4gQnV0IG1h
eWJlIEthbGxlIGNhbiBjb3JyZWN0IG1lIGhlcmUuDQoNCkN1cnJlbnRseSBJJ20gbm90IGF3YXJl
IG9mIGFueSBleHRyYSBwcm9wZXJ0aWVzIHdoaWNoIHdlIHdvdWxkIG5lZWQgaW4NCmF0aDEwaywg
aGF2aW5nIHRoZSBjdXN0b20gYm9hcmQgZmlsZSBzZWVtcyB0byBiZSB0aGUgb25seSByZXF1aXJl
bWVudCBJDQpoYXZlIHNlZW4uDQoNCj4+ID4gVGhleSBhcmUgYmFzaWNhbGx5ICJxY29tLGlwcTQw
MTktd2lmaSIgKyBhIHByb2R1Y3Qgc3BlY2lmaWMgc3RyaW5nLiBUaGUgZmlyc3QNCj4+ID4gcGFy
dCBpcyB0aGVyZWZvcmUgdGhlIHN0cmluZyB3aGljaCBpZGVudGlmaWVzIHRoZSB3aWZpIGRldmlj
ZShzKSBpbiB0aGUNCj4+ID4gUUNBNDAxOC80MDE5IFNvQy4gVGhlIHByb2R1Y3Qgc3BlY2lmaWMg
c3RyaW5nIGlzIHNpbXBseSB0aGUgcGFydCAob3IgYQ0KPj4gPiB2YXJpYXRpb24gb2YgaXQpIHdo
aWNoIHdvdWxkIGJlZW4gdXNlZCBiZWZvcmUgaW4NCj4+ID4gInFjb20sYXRoMTBrLWNhbGlicmF0
aW9uLXZhcmlhbnQiIC0ganVzdCB0byBtYWtlIGl0ICJ1c2UgYSBtb3JlIHNwZWNpZmljDQo+PiA+
IGNvbXBhdGlibGUgc3RyaW5nIi4NCj4+IA0KPj4gSXQgd291bGQgcHJvYmFibHkgYmUgbW9yZSBs
aWtlOiAiYXN1cyxydC1hYzU4dS13aWZpIiwgInFjb20saXBxNDAxOS13aWZpIg0KPj4gDQo+PiBB
IG1vcmUgc3BlY2lmaWMgY29tcGF0aWJsZSBpcyBpbnN1cmFuY2UgdGhhdCBhdCBzb21lIGxhdGVy
IHBvaW50IGluDQo+PiB0aW1lIHlvdSBjYW4gZGlzdGluZ3Vpc2ggYmV0d2VlbiAyIGJvYXJkcyBk
dWUgdG8gc29tZSBkaWZmZXJlbmNlIGV2ZW4NCj4+IGlmIG5vdyB5b3UgYmVsaWV2ZSB0aGV5IGFy
ZSAidGhlIHNhbWUiLg0KPiBbLi4uXQ0KPj4gSSB0aGluayB0aGUgc2VwYXJhdGUgcHJvcGVydHkg
aXMgZmluZSBpZiB0aGlzIGlzIHRoZSBvbmx5IG9uZSB5b3UNCj4+IGVudmlzaW9uIG5lZWRpbmcg
dG8gYWRkLiBJZiB0aGVyZSdzIDEwIG1vcmUgcHJvcGVydGllcywgdGhlbiBJJ2QgZmVlbA0KPj4g
bW9yZSBzdHJvbmdseSB0b3dhcmRzIGEgYm9hcmQgc3BlY2lmaWMgY29tcGF0aWJsZSBzdHJpbmcu
DQo+DQo+IFRoYW5rIHlvdS4gTGV0J3Mgd2FpdCBhIGxpdHRsZSBiaXQgaW4gY2FzZSBzb21lb25l
IGZyb20gUUNBL0NvZGVhdXJvcmENCj4gaGFzIHNvbWUgYWRkaXRpb25hbCBpbnB1dC4NCg0KSSBk
aWRuJ3Qgc2VlIGFueSBjb21tZW50cyBmcm9tIGFueW9uZSBlbHNlIGFuZCBJIHRoaW5rIFN2ZW4n
cyBhcHByb2FjaA0KaGVyZSBpcyB0aGUgYmVzdC4gU3ZlbiwgY2FuIHlvdSBzdWJtaXQgdjIgc28g
dGhhdCB3ZSBnZXQgYW4gYWNrIGZyb20NCmRldmljZSB0cmVlIG1haW50YWluZXJzIGFuZCBJIGNh
biBhcHBseSB0aGVzZT8NCg0KLS0gDQpLYWxsZSBWYWxv
