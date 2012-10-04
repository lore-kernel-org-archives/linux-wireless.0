Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60601 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2JDWyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 18:54:18 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so839632eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2012 15:54:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506E10B7.4060406@candelatech.com>
References: <506DDA1D.1090106@candelatech.com> <CAGRGNgVAehhN8CdwYrG8H4kuad=Kt5tPOHSKCSH8xm-OC=z6aw@mail.gmail.com>
 <506E10B7.4060406@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 5 Oct 2012 08:53:55 +1000
Message-ID: <CAGRGNgWhx57oB-wf7DE+V_A1h1K0uHWs0F2jJNyFR58eJ_X5Hg@mail.gmail.com> (sfid-20121005_005423_290168_775FCF16)
Subject: Re: Questions on direct-cabling 3x3 MIMO systems (ath9k)
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Fri, Oct 5, 2012 at 8:41 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/04/2012 03:36 PM, Julian Calaby wrote:
>>
>> Hi Ben,
>>
>> On Fri, Oct 5, 2012 at 4:49 AM, Ben Greear <greearb@candelatech.com>
>> wrote:
>>>
>>> I finally got my 3-attenuator system up and running,
>>> and I'm starting to do some tests.
>>>
>>> AP and Station are running 3.5.5+, ath9k ar9380 NICs.
>>> Channel 157, HT40, no encryption.
>>>
>>> One question right away:  Should I expect decent performance
>>> if I directly cable 2 wifi NICs, where one is acting as AP and
>>> the other as station?  I'm cabling ch0 to ch0, ch1 to ch1, ch2 to ch2.
>>
>>
>> Going off on a tangent: arguably it shouldn't matter which channel on
>> the AP card is connected to which channel on the STA card. I wonder
>> what results you'd get if you cabled them in each combination and
>> tested the throughput keeping the other variables the same. I also
>> wonder what impact it would have on the throughput if you started
>> disconnecting the cables.
>
>
> I doubt it matters either....just seemed sane to start with something
> I could easily keep track of in my head :)

Fair enough.

> I had really shitty performance when I had only one cable connected
> to the station, but I think it is probably related to rate-control,
> which seems too aggressive.  When I force things to slower speeds
> it works fine.  I'm starting to look into that now.
>
> I hope to eventually produce big pretty graphs reporting signal, rx-rate,
> etc over various attenuations...but still got a ways to go first!

Pretty graphs are always useful. It'd be nice to compare other brands
/ models of card too, but I'm guessing that's outside the scope of
what you're planning to achieve.

Are you planning to open-source any of the software / hardware you're
making to do this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
