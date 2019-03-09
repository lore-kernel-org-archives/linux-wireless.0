Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C57FC43381
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B0B420836
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfCINbs convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 08:31:48 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39260 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbfCINbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 08:31:48 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x29DV9vM017743, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x29DV9vM017743
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 9 Mar 2019 21:31:09 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Sat, 9 Mar 2019 21:31:08 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Sat, 9 Mar 2019
 21:31:08 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>
Subject: RE: [PATCH v6 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v6 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHU1bbCfTdXWE9URU+/NA55SUr0rqYBjxWAgAG6wWY=
Date:   Sat, 9 Mar 2019 13:31:07 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17BCBDC@RTITMBSVM04.realtek.com.tw>
References: <1552053343-6513-1-git-send-email-yhchuang@realtek.com>,<2d8b07cb-e6c7-6af1-57d3-c28934ae592a@lwfinger.net>
In-Reply-To: <2d8b07cb-e6c7-6af1-57d3-c28934ae592a@lwfinger.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [1.168.42.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> Tony,
> 
> Somehow files util.c and util.h got dropped from the rtw88 directory in the V6
> patches.
> 
> Larry

Seems like I missed them when I was squashing the two patch sets :(
Will resend v7 for review.
Thanks

Yan-Hsuan
