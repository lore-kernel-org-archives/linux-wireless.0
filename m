Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C5EC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F422085A
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfAHCtG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 21:49:06 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:50918 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfAHCtG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 21:49:06 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x082mdsQ016517, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x082mdsQ016517
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 8 Jan 2019 10:48:39 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 8 Jan 2019 10:48:39 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 8 Jan 2019
 10:48:38 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: RE: [PATCH v2 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v2 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUkskBgCtjSWw+WUynnj98ZXihZqWk0X+w
Date:   Tue, 8 Jan 2019 02:48:37 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D177C217@RTITMBSVM04.realtek.com.tw>
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
        <20181212090743.GA13331@redhat.com> <87bm5pzrin.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bm5pzrin.fsf@kamboji.qca.qualcomm.com>
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

> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > On Fri, Nov 16, 2018 at 07:31:06PM +0800, yhchuang@realtek.com wrote:
> >> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >>
> >> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> >> rtw88 supports 8822BE and 8822CE chips, and will be able to support
> >> multi-vif combinations in run-time.
> >>
> >> For now, only PCI bus is supported, but rtw88 was originally designed
> >> to optionally support three buses includes USB & SDIO. USB & SDIO modules
> >> will soon be supported by rtw88, with configurable core module to fit
> >> with different bus modules in the same time.
> >
> > Kalle, is here anything that stop the driver being merged ?
> 
> First of all, thanks for reviewing this. It helps a lot.
> 
> Before I'm willing to apply this needs review both from Johannes and me.
> And of course some build testing in pending branch, I'll try to setup
> that ASAP.
> 
> --
> Kalle Valo
> 

Hi Kalle and Johannes,

Is rtw88 being reviewed ? Thanks !

--
Yan-Hsuan

