Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52388 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0HUDH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 23:07:27 -0400
Received: by ewy23 with SMTP id 23so2601621ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Aug 2010 20:07:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C618713.9030303@candelatech.com>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org>
	<AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
	<4C55F377.6040404@candelatech.com>
	<AANLkTinGqWZ8o9L=ePsbgzWtitWAHCt3=g_z6BM7EpjO@mail.gmail.com>
	<4C618713.9030303@candelatech.com>
Date: Sat, 21 Aug 2010 13:07:26 +1000
Message-ID: <AANLkTikanjZf0LEqZjw5toeJz02Tcs6EcAiNdagJh=sQ@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've managed to compile and get bens kernel installed.  the problem i
had (for future reference) was the physical media not being
recognised.  adding rootdelay=130 to the kernel options seemed to have
fixed that.

On 11 August 2010 03:06, Ben Greear <greearb@candelatech.com> wrote:
> On 08/10/2010 09:54 AM, Luis R. Rodriguez wrote:
>>
>> On Sun, Aug 1, 2010 at 3:21 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>
>>> You would not believe how hard it is to keep up with the wireless tree.
>>>  Last time,
>>> by the time we had something stable, upstream had changed too much to
>>> merge.
>>
>> This is why you should not do your development outside of
>> wireless-testing. If you are doing development on a stable kernel tree
>> then you will likely run into huge issues. You should do development
>> on wireless-testing.git, always rebase when John has a new update, and
>> break your changes out into a small changes as possible. If you follow
>> these basic rules I believe you will likely have better luck with
>> keeping your code up to date.
>
> That sounds nice, but at that time I was carrying a lot of other patches
> needed to make my test environment work.  Fortunately, .35 pretty much
> works out of the box, so I can develop on pristine upstream kernels now.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
