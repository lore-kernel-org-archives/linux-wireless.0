Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39478 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbbAOXDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 18:03:30 -0500
Received: by mail-wi0-f176.google.com with SMTP id z2so609289wiv.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2015 15:03:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21687.32167.596541.729136@gargle.gargle.HOWL>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
 <87r3uy4t9y.fsf@kamboji.qca.qualcomm.com> <21685.35179.110539.780864@gargle.gargle.HOWL>
 <87bnm01ojf.fsf@kamboji.qca.qualcomm.com> <21687.29026.962216.812998@gargle.gargle.HOWL>
 <87vbk8zcr1.fsf@kamboji.qca.qualcomm.com> <21687.30578.746681.850817@gargle.gargle.HOWL>
 <87mw5kzbog.fsf@kamboji.qca.qualcomm.com> <21687.32167.596541.729136@gargle.gargle.HOWL>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 16 Jan 2015 10:03:08 +1100
Message-ID: <CAGRGNgUB3K6KG1Stst9vwQsGQ03DXGBx_fs6NZ+KEGA1HS2npA@mail.gmail.com> (sfid-20150116_000333_762155_321401AB)
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
To: Sujith Manoharan <sujith@msujith.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Thu, Jan 15, 2015 at 7:43 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> Kalle Valo wrote:
>> Yeah, but everyone want higher throughput (including me). So what value
>> is best in your opinion?
>
> Lower throughput has been okay for all this time, with a value
> of 16. I suppose the value can be retained to not cause regressions
> on AP135 or other platforms with a low-powered CPU. As Michal mentioned,
> this value allows AP135 to function without the watchdog rebooting
> the board.

Can we detect if this parameter is too high / low and adjust / limit
it on the fly?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
