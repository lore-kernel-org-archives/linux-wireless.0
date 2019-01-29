Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E7CC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 13:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F03A20870
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 13:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfA2NCG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 08:02:06 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:59433 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfA2NCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 08:02:06 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0TD1kkI003472, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0TD1kkI003472
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 29 Jan 2019 21:01:46 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 29 Jan
 2019 21:01:46 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUt6iEoGWsIdSZ5km8koIDZ4UJzKXGNIKQ
Date:   Tue, 29 Jan 2019 13:01:44 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1798ACF@RTITMBSVM04.realtek.com.tw>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
        <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
        <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
 <87lg33uc6o.fsf@purkki.adurom.net>
In-Reply-To: <87lg33uc6o.fsf@purkki.adurom.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> I suggest to look at criticality of the bug and size of the patch. For
> example, if the bug is a minor and the patch is large you should
> definitely drop that. And smaller fixes to severe bugs you should
> definitely again include them.
> 
> Just remember to list in the changelog every change you made since
> previous version.
> 

Hi Kalle,

One more question, should I merge the trivial patches into the original
patch set and resend them like [PATCH v4 00/13].

Or should I add them after the 13 patches for people to review easily.
Such as [PATCH v4 00/21]. Which do you prefer?
Thanks.

Yan-Hsuan

