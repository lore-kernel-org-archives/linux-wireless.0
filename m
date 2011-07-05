Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1GEXGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 19:06:12 -0400
Message-ID: <4E1398D3.7000703@gmail.com> (sfid-20110706_010639_436071_B5AF8AE8)
Date: Tue, 05 Jul 2011 16:05:55 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: WARNING: at kernel/timer.c:1011 del_timer_sync+0xa9/0xc4()
References: <4E0D5E42.20702@gmail.com>	<BANLkTinBJBnZbHPpdmnYX3EV0SYFd-pRDA@mail.gmail.com>	<4E0D6B8D.6000601@gmail.com>	<BANLkTimX4=Szn_JT49SLw4BvGxg3Qe0rYw@mail.gmail.com>	<4E0ED42E.3020303@gmail.com>	<4E113498.7050900@gmail.com>	<CAD2nsn0XjoMUMv6e9SuSBUAwq0Lq5QCPMBWTnPZmsndg_XYcvw@mail.gmail.com>	<4E124D42.8040808@gmail.com> <CAD2nsn2AhxWCT0XLn46n4GTE7-HOkT2HzKf6=6RsG3PbSB0hsw@mail.gmail.com>
In-Reply-To: <CAD2nsn2AhxWCT0XLn46n4GTE7-HOkT2HzKf6=6RsG3PbSB0hsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2011 09:39 PM, Mohammed Shafi wrote:
>>
>>
>> FWIW below is my .config that I am using that seems to be having this
>> warning message show up.
>>
>> latest pull of the Mainline dmesg:
>>   http://fpaste.org/
>>
>
> hello Justin,
>
> we doubt whether this patch is there in your linux-kernel tree you are
> using, even though it is there in wireless-testing tree. please try to
> apply this patch and see you can hit the warning
> https://patchwork.kernel.org/patch/915952/
>
> thanks,
> shafi
>

o.k.. appologize for the slow response(have to work!), anyways I rebased 
the patch to the current Mainline, and am running it.
(so far no signs of a warning message)
dmesg with patch applied:
http://fpaste.org/jTX3/

will run it a while to see if anything occurs.

Justin P. Mattock
