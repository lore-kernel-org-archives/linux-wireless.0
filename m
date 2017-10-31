Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:43709 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbdJaPAa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 11:00:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
Date: Tue, 31 Oct 2017 15:00:21 +0000
Message-ID: <8760av1hx8.fsf@kamboji.qca.qualcomm.com> (sfid-20171031_160032_854210_B7DA74DF)
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
        <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
        <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
        <52655c07-aba1-525e-8c81-e420eafc329f@dd-wrt.com>
In-Reply-To: <52655c07-aba1-525e-8c81-e420eafc329f@dd-wrt.com> (Sebastian
        Gottschall's message of "Tue, 31 Oct 2017 15:52:15 +0100")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

U2ViYXN0aWFuIEdvdHRzY2hhbGwgPHMuZ290dHNjaGFsbEBkZC13cnQuY29tPiB3cml0ZXM6DQoN
Cj4gdGhlIGZvbGxvd2luZyBwYXRjaGxpbmVzIGluIHRoZSB2MyBwYXRjaCBsb29rIHdyb25nDQo+
DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIElDViAqLw0KPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoc3RhdHVzLT5mbGFnICYgUlhfRkxBR19JQ1ZfU1RSSVBQ
RUQgJiYNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbmN0eXBlICE9
IEhUVF9SWF9NUERVX0VOQ1JZUFRfQUVTX0NDTV9XUEEyKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2tiX3RyaW0obXNkdSwgbXNkdS0+bGVuIC0NCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGF0aDEwa19odHRfcnhfY3J5cHRvX3RhaWxfbGVuKGFyLA0KPiBlbmN0eXBlKSk7DQo+
DQo+DQo+IHRoZSBlbmN0eXBlICE9IHdwYTIgaXNudCBlbm91Z2ggc2luY2UgaXQgYWxzbyBiZWxv
bmdzIHRvIGNjbXAtMjU2LA0KPiBnY21wIG1vZGVzIGV0Yy4NCg0KNC4xNCBkb2Vzbid0IHN1cHBv
cnQgQ0NNUC0yNTYgbm9yIEdDTVAgbW9kZXMgeWV0LiBEaWQgeW91IGNoZWNrIHRoZQ0Kc2VwYXJh
dGUgcGF0Y2ggZm9yIDQuMTU6DQoNCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gv
MTAwMjkwOTcvDQoNCi0tIA0KS2FsbGUgVmFsbw0K
