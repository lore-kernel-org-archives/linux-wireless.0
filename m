Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50969 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2JDWmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 18:42:01 -0400
Message-ID: <506E10B7.4060406@candelatech.com> (sfid-20121005_004208_332055_06ABED6F)
Date: Thu, 04 Oct 2012 15:41:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Questions on direct-cabling 3x3 MIMO systems (ath9k)
References: <506DDA1D.1090106@candelatech.com> <CAGRGNgVAehhN8CdwYrG8H4kuad=Kt5tPOHSKCSH8xm-OC=z6aw@mail.gmail.com>
In-Reply-To: <CAGRGNgVAehhN8CdwYrG8H4kuad=Kt5tPOHSKCSH8xm-OC=z6aw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2012 03:36 PM, Julian Calaby wrote:
> Hi Ben,
>
> On Fri, Oct 5, 2012 at 4:49 AM, Ben Greear <greearb@candelatech.com> wrote:
>> I finally got my 3-attenuator system up and running,
>> and I'm starting to do some tests.
>>
>> AP and Station are running 3.5.5+, ath9k ar9380 NICs.
>> Channel 157, HT40, no encryption.
>>
>> One question right away:  Should I expect decent performance
>> if I directly cable 2 wifi NICs, where one is acting as AP and
>> the other as station?  I'm cabling ch0 to ch0, ch1 to ch1, ch2 to ch2.
>
> Going off on a tangent: arguably it shouldn't matter which channel on
> the AP card is connected to which channel on the STA card. I wonder
> what results you'd get if you cabled them in each combination and
> tested the throughput keeping the other variables the same. I also
> wonder what impact it would have on the throughput if you started
> disconnecting the cables.

I doubt it matters either....just seemed sane to start with something
I could easily keep track of in my head :)

I had really shitty performance when I had only one cable connected
to the station, but I think it is probably related to rate-control,
which seems too aggressive.  When I force things to slower speeds
it works fine.  I'm starting to look into that now.

I hope to eventually produce big pretty graphs reporting signal, rx-rate,
etc over various attenuations...but still got a ways to go first!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

