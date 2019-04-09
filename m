Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AEBC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 10:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 170752084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 10:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfDIKNB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:13:01 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50187 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfDIKNB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 06:13:01 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x39ACHlf025528, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x39ACHlf025528
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 9 Apr 2019 18:12:18 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 9 Apr 2019
 18:12:17 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: RE: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHU7f7V+GVXIkmks0i6acEtkruVp6Yzmz3w
Date:   Tue, 9 Apr 2019 10:12:16 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17D6AD6@RTITMBSVM04.realtek.com.tw>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
        <20190325143611.sjwwjqtrftxntwyk@penguin>       <20190326075414.GA8598@redhat.com>
        <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
        <F7CD281DE3E379468C6D07993EA72F84D17CB940@RTITMBSVM04.realtek.com.tw>
        <20190327102623.GA20943@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D17D50A4@RTITMBSVM04.realtek.com.tw>
 <87zhp0g2a5.fsf@codeaurora.org>
In-Reply-To: <87zhp0g2a5.fsf@codeaurora.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Monday, April 08, 2019 7:33 PM
> To: Tony Chuang
> Cc: Brian Norris; Johannes Berg; linux-wireless; Greg Kroah-Hartman; Pkshih;
> Andy Huang; Larry Finger; Stanislaw Gruszka
> Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
> wireless network chips
> 
> Tony Chuang <yhchuang@realtek.com> writes:
> 
> > Hi Kalle
> >
> >> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> >> Sent: Wednesday, March 27, 2019 6:26 PM
> >> To: Tony Chuang
> >> Cc: Brian Norris; Kalle Valo; Johannes Berg; linux-wireless; Greg
> Kroah-Hartman;
> >> Pkshih; Andy Huang; Larry Finger
> >> Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
> >> wireless network chips
> >>
> >
> > It's just a gentle reply to ask if rtw88 is getting merged.
> > Are you still reviewing or is there anything I can help.
> 
> I just have been busy with other stuff, sorry. I'll try find time for
> this soon.
> 

It's OK. If you need any help just let me know. :)

BTW, I want to change the license from GPL to Dual BSD/GPL.
Would you want to change them in the initial patch set, or I send a separate
one after it got merged?

Yan-Hsuan
