Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49515 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab0HJRGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 13:06:37 -0400
Message-ID: <4C618713.9030303@candelatech.com>
Date: Tue, 10 Aug 2010 10:06:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Ryszard <ryszard99@gmail.com>,
	Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Subject: Re: virtual access poitns (ath5k/mac80211)
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com> 	<201008011137.49528.florian@openwrt.org> <AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com> 	<4C55F377.6040404@candelatech.com> <AANLkTinGqWZ8o9L=ePsbgzWtitWAHCt3=g_z6BM7EpjO@mail.gmail.com>
In-Reply-To: <AANLkTinGqWZ8o9L=ePsbgzWtitWAHCt3=g_z6BM7EpjO@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2010 09:54 AM, Luis R. Rodriguez wrote:
> On Sun, Aug 1, 2010 at 3:21 PM, Ben Greear<greearb@candelatech.com>  wrote:

>> You would not believe how hard it is to keep up with the wireless tree.
>>   Last time,
>> by the time we had something stable, upstream had changed too much to merge.
>
> This is why you should not do your development outside of
> wireless-testing. If you are doing development on a stable kernel tree
> then you will likely run into huge issues. You should do development
> on wireless-testing.git, always rebase when John has a new update, and
> break your changes out into a small changes as possible. If you follow
> these basic rules I believe you will likely have better luck with
> keeping your code up to date.

That sounds nice, but at that time I was carrying a lot of other patches
needed to make my test environment work.  Fortunately, .35 pretty much
works out of the box, so I can develop on pristine upstream kernels now.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

