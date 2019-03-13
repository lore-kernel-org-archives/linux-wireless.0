Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79649C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 07:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B5332171F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 07:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfCMHG4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:06:56 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48867 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfCMHGy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 03:06:54 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2D76PdC024833, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2D76PdC024833
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 13 Mar 2019 15:06:25 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Wed, 13 Mar 2019 15:06:25 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHU2VNS+GVXIkmks0i6acEtkruVp6YJHu3ngAAD34A=
Date:   Wed, 13 Mar 2019 07:06:24 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17BF35B@RTITMBSVM04.realtek.com.tw>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <87wol31d8k.fsf@codeaurora.org>
In-Reply-To: <87wol31d8k.fsf@codeaurora.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> 
> <yhchuang@realtek.com> writes:
> 
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> > rtw88 now supports RTL8822BE/RTL8822CE now, with basic station mode
> > functionalities. The firmware for both can be found at linux-firmware.
> >
> 
> [...]
> 
> > v8
> >
> >  - add prefix "rtw_" to *_rates and corresponding *_sizes, otherwise
> >    the extern will confuse the linker there are multiple definitions
> >    with brcmsmac driver
> 
> I tried to explain this already last time, but maybe I wasn't clear
> enough so I'll try again: PLEASE do not submit any new versions of rtw88
> until I explicitly ask you to send v9. If you post new versions too
> frequently it makes the review harder. Reviewing full driver is very
> different from reviewing normal patches, the patches are larger and it
> takes more time to review.

Sorry about that. I thought " please fix that in the next version " was asking
me to send the next version. Now I get it, will include these fixes in my tree,
and send v9 until you ask to.

> 
> Also you did not switch to using GENMASK() like I asked.
> 
> So no more new versions of rtw88 until everyone have reviewed v8 and I
> ask you to send v9.
> 
> --
> Kalle Valo


Yan-Hsuan

