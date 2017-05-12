Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59180 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755963AbdELOMj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 10:12:39 -0400
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Kalle Valo <kvalo@codeaurora.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
References: <20170323133048.30062-2-sw@simonwunderlich.de>
 <1811221.G4Vz0DPyQ8@prime>
 <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de>
 <1863250.VEhGCjvYY0@prime> <87efvvvd0t.fsf@kamboji.qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Steve deRosier <derosier@gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <1c5720d5-8264-26a8-a63e-b225524471cc@candelatech.com> (sfid-20170512_161243_576049_D6BA3798)
Date: Fri, 12 May 2017 07:12:36 -0700
MIME-Version: 1.0
In-Reply-To: <87efvvvd0t.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/11/2017 04:38 AM, Kalle Valo wrote:
> Simon Wunderlich <sw@simonwunderlich.de> writes:
>
>> it seems like there was some discussion here and I wouldn't expect too many
>> more opinions ... do you think we can have a decision based on what has been
>> discussed here?
>
> Well, there was an excellent reply from Steve and quite a few "in my
> opinion this is safe" type of answers. [1] But bluntly said it does not
> really matter what we (the engineers) think. What really matters here
> are regulatory authorities' opinions and rulings. In that respect here
> are few items I want to point out:
>
> o I suspect that from someone's, who is not familiar with software
>   engineering, point of view there is still quite a diffference from
>   modifiying source code or just enabling few options from Kconfig with
>   a custom regdb rule.

If someone with real authority ever complains, then the code could be
backed out again.  Your opinion seems not much more informed than the
rest of us discussing this.

>
> o I don't know about other countries, but in Finland applying for any
>   type of license (even if just to a license to drive a moped) needs
>   both time and money. So there is significant effort anyway needed to
>   legally use this band. And how many users there really are is unclear.

This is almost certainly not going to be used by regular end-users.  It is going to be
used by public safety organizations who are buying equipment from companies
using open-wrt, LEDE, or similar, or possibly small teams at public safety
organizations doing the work themselves.  Rather than having each of these vendors
hack their own crap into their kernels or forcing the the organizations to use Cisco gear,
we could work on it together.

Anyway, if upstream is blocked, then maybe we could work on getting this into LEDE?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
