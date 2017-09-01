Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10582 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdIAXN3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 19:13:29 -0400
From: Ryan Hsu <ryanhsu@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [v3,1/2] ath10k: add the PCI PM core suspend/resume ops
Date: Fri, 1 Sep 2017 23:13:19 +0000
Message-ID: <ac6334cb-6a59-88db-cf3e-9efbfc0a9286@qti.qualcomm.com> (sfid-20170902_011334_283557_46C7EDC6)
References: <1503438455-6133-1-git-send-email-ryanhsu@qti.qualcomm.com>
 <f4652c401e1f462d89b4611afe9bd623@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <f4652c401e1f462d89b4611afe9bd623@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gMDgvMzEvMjAxNyAwNTo1MiBBTSwgS2FsbGUgVmFsbyB3cm90ZToNCg0KPiBUaGlzIGhhZCBh
IHdhcm5pbmc6DQo+DQo+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvcGNpLmM6MzY1
MToxOiB3YXJuaW5nOiBzeW1ib2wgJ2F0aDEwa19wY2lfcG1fb3BzJyB3YXMgbm90IGRlY2xhcmVk
LiBTaG91bGQgaXQgYmUgc3RhdGljPw0KPg0KPiBJIGZpeGVkIGl0IGluIHRoZSBwZW5kaW5nIGJy
YW5jaCBieSBtYWtpbmcgaXQgc3RhdGljOg0KPg0KPiBzdGF0aWMgU0lNUExFX0RFVl9QTV9PUFMo
YXRoMTBrX3BjaV9wbV9vcHMsDQo+IAkJCSBhdGgxMGtfcGNpX3BtX3N1c3BlbmQsDQo+IAkJCSBh
dGgxMGtfcGNpX3BtX3Jlc3VtZSk7DQo+DQo+IFBsZWFzZSByZXZpZXcuDQo+DQoNClllcyBhbmQg
dGhhbmtzIQ0KDQotLSANClJ5YW4gSHN1DQo=
