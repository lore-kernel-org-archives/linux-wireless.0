Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35726 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759215AbeD0Wnf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 18:43:35 -0400
Received: by mail-pf0-f170.google.com with SMTP id j5so2473319pfh.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2018 15:43:35 -0700 (PDT)
Date: Sat, 28 Apr 2018 08:41:59 +1000
From: Barry Day <briselec@gmail.com>
To: Pkshih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
Message-ID: <20180427224156.GA18163@thinktank.home.org> (sfid-20180428_004655_035418_77796AEF)
References: <20180425020820.6141-1-pkshih@realtek.com>
 <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 27, 2018 at 05:44:16AM +0000, Pkshih wrote:
>
> The registers reside in driver causes error frequently, because MAC register
> is maintained by Realtek's MAC team so they create this module to avoid mistakes.
> Another benefit is to make it possible to become a thin driver, because many
> common functions are provided, so duplicate code will be reduced.

How is it possible to create a thin driver by adding lots more code and layers
of indirection ??? and writing it in a way that it won't compile without the
code for every type of bus interface even though most modules only use one ?

It's a horrible pile of garbage slapped together by an inexperienced
programmer. Its a major deterrent for anyone looking at working on one of
the latest realtek drivers.
