Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410CDC10F00
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 02:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F91420835
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 02:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfCDCec (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 21:34:32 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:34788 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfCDCec (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 21:34:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x242YKTw022481, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x242YKTw022481
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 4 Mar 2019 10:34:20 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Mon, 4 Mar 2019 10:34:19 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "David R. Bergstein" <david.r.bergstein@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Realtek r8822be kernel module does not negotiate 802.11ac connection
Thread-Topic: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
Thread-Index: AQHUzlJcsGthwPPLIUG44IxOn8EK26XzbiOQgAIdBICAAPpYAIAAU0EAgAA4CoCAABMnAIAABeyAgAAKJoCAAGeuAIADLLdA
Date:   Mon, 4 Mar 2019 02:34:19 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17B22F1@RTITMBSVM04.realtek.com.tw>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
 <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
 <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
 <1693ddc0fd0.278a.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <1693ddc0fd0.278a.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJlbmQgVmFuIFNwcmll
bCBbbWFpbHRvOmFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb21dDQo+IA0KPiA+IExhcnJ5LA0K
PiA+DQo+ID4gU29ycnkgYWJvdXQgYWxsIHRoZXNlIGV4dHJhIHJlcGxpZXMuwqAgU2hvcnRseSBh
ZnRlciBJIHNlbnQgbXkgbGFzdA0KPiA+IG1lc3NhZ2UgbXkgYWNjZXNzIHBvaW50IHN0YXJ0ZWQg
cmVjb2duaXppbmcgdGhlIGNvbm5lY3Rpb24gYXMgODAyLjExYWMNCj4gPiB3aXRoIFBIWSBSYXRl
IC8gTW9kdWxhdGlvbiBSYXRlIG9mIDg2Ni42IE1icHMuwqAgV2hhdCBpcyBzb21ld2hhdA0KPiA+
IG1pc2xlYWRpbmcgaXMgdGhlIGluZm9ybWF0aW9uIHJlcG9ydGVkIGJ5IGl3Y29uZmlnIChzZWUg
Yml0IHJhdGUgYmVsb3cpLg0KPiANCj4gTXkgYmV0IHdvdWxkIGJlIHRoYXQgaXQgaXMgbml0cmF0
ZSBhdCB3aGljaCBiZWFjb24gb3IgcHJvYmUgcmVzcG9uc2UgaXMNCj4gcmVjZWl2ZWQuIFJlZ2Fy
ZGxlc3MgSSB3b3VsZCBzdWdnZXN0IHVzaW5nIGl3IGluIHRoaXMgZGF5IGFuZCBhZ2UuDQo+IA0K
PiBSZWdhcmRzLA0KPiBBcmVuZA0KPiANCj4gPiAkIGl3Y29uZmlnIHdsbzENCj4gPiB3bG8xwqDC
oMKgwqDCoCBJRUVFIDgwMi4xMcKgIEVTU0lEOiJYWFhYWFhYWFhYLTVHIg0KPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoCBNb2RlOk1hbmFnZWTCoCBGcmVxdWVuY3k6NS4yMiBHSHrCoCBBY2Nlc3MgUG9p
bnQ6DQo+ID4geHg6eHg6eHg6eHg6eHg6eHgNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgQml0IFJh
dGU9Ni41IE1iL3PCoMKgIFR4LVBvd2VyPTIzIGRCbQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoCBS
ZXRyeSBzaG9ydCBsaW1pdDo3wqDCoCBSVFMgdGhyOm9mZsKgwqAgRnJhZ21lbnQgdGhyOm9mZg0K
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoCBQb3dlciBNYW5hZ2VtZW50Om9uDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgIExpbmsgUXVhbGl0eT03MC83MMKgIFNpZ25hbCBsZXZlbD0tNDAgZEJtDQo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgIFJ4IGludmFsaWQgbndpZDowwqAgUnggaW52YWxpZCBjcnlwdDow
wqAgUnggaW52YWxpZCBmcmFnOjANCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgVHggZXhjZXNzaXZl
IHJldHJpZXM6MMKgIEludmFsaWQgbWlzYzoxMcKgwqAgTWlzc2VkIGJlYWNvbjowDQo+ID4NCj4g
PiBTaW5jZXJlbHksDQo+ID4NCj4gPiBEYXZpZCBSLiBCZXJnc3RlaW4NCj4gDQoNCkl0J3MgYmVj
YXVzZSB0aGUgaW5pdGlhbCB2ZXJzaW9uIGRvZXMgbm90IGNvbGxlY3QgdHhfcmF0ZSByZXBvcnQg
ZnJvbSB0aGUgZmlybXdhcmUuDQpTbyBpdCBqdXN0IHByaW50IG91dCB0aGUgaW5pdGlhbCB2YWx1
ZS4gV2lsbCBiZSBhZGRlZCBpbiB0aGUgbmV4dCBzZXJpZXMuIFRoYW5rcyENCg0KWWFuLUhzdWFu
DQoNCg==
