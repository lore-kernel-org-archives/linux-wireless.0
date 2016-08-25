Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49758 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbcHYSvN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 14:51:13 -0400
From: "Pedersen, Thomas" <twp@qca.qualcomm.com>
To: "Mishol, Guy" <guym@ti.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wlcore: mesh: add zone time sync support
Date: Thu, 25 Aug 2016 18:50:59 +0000
Message-ID: <1472151013.3432.33.camel@qca.qualcomm.com> (sfid-20160825_205119_033201_918FF0CE)
References: <20160808085706.22668-1-guym@ti.com>
         <1471538527.3432.21.camel@qca.qualcomm.com>
         <874m6h5bex.fsf@purkki.adurom.net>
         <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com>
In-Reply-To: <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU3VuLCAyMDE2LTA4LTIxIGF0IDEwOjEzICswMDAwLCBNaXNob2wsIEd1eSB3cm90ZToNCj4g
S2FsbGUvVGhvbWFzLA0KPiBUaGFua3MgZm9yIHlvdXIgZmVlZGJhY2suDQo+IA0KPiBUaGlzIHRp
bWUgc3luYyBzdXBwb3J0IGlzIGRpZmZlcmVudCBmcm9tIHRoZSBvbmUgdGhhdCBtYWM4MDIxMSBt
YWludGFpbnMgd2l0aCBtZXNoIHBlZXJzLg0KPiBUaGlzIHRpbWUgc3luYyBpcyBtb3N0bHkgdXNl
ZCBieSB1cHBlciBsYXllcnMgZm9yIHNldmVyYWwgYXBwbGljYXRpb25zIChsaWtlIGF1ZGlvKS4N
Cj4gSW4gdGhpcyBjYXNlIHdlIGFsbG93IHRoZSB1c2VyIHRvIGNvbmZpZ3VyZSBmb3IgZWFjaCB6
b25lIHdobyB3aWxsIGJlIHRoZSBzeW5jaHJvbml6ZXIuDQo+IFlvdSBjYW4gcmVmZXIgdG8gdGhl
IGZvbGxvd2luZyBBcHBsaWNhdGlvbiBSZXBvcnQgKGNoYXB0ZXIgNikgZm9yIG1vcmUgaW5mb3Jt
YXRpb246IGh0dHA6Ly93d3cudGkuY29tL2xpdC9hbi9zd2FhMTY2L3N3YWExNjYucGRmDQoNClNv
IGl0IGJyZWFrcyByZWd1bGFyIG1lc2ggc3luY2hyb25pemF0aW9uPyBQb3dlciBTYXZlLCBhbmQg
aW4gdGhlIGZ1dHVyZQ0KcG9zc2libHkgREZTIGFuZCBNQ0NBIHJlbHkgb24gdGhpcyB0byB3b3Jr
Lg0KDQpJdCBzb3VuZHMgbGlrZSB5b3Ugd2FudCBzb21lIGFic29sdXRlIFRTRiB0aW1lIHN5bmNo
cm9uaXplZCB3aXRoaW4gMjB1cy4NCk1lc2ggVFNGIHN5bmNocm9uaXphdGlvbiBjYW4gcHJvdmlk
ZSB0aGlzLCBpdCdzIGp1c3QgYSBsaXR0bGUgbW9yZQ0KY29tcGxpY2F0ZWQgYXMgeW91J2xsIG5l
ZWQgdG8gY29tcHV0ZSBhdCB0aGUgYXBwbGljYXRpb24gbGV2ZWwgdXNpbmcgdGhlDQpwZXItc3Rh
IG9mZnNldHMuIE1lc2ggc3luY2hyb25pemF0aW9uIGFjY3VyYWN5IHdhcyBwcmV0dHkgZ29vZCBJ
SVJDLA0KdW5mb3J0dW5hdGVseSBJIGRvbid0IGhhdmUgYW55IHRlc3QgZGF0YSB0byBzaGFyZSA6
KA0KDQp0aG9tYXMNCg==
