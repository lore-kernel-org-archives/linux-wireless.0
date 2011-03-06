Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:48408 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1CFRb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 12:31:28 -0500
Received: by gwb15 with SMTP id 15so2108227gwb.10
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 09:31:28 -0800 (PST)
Message-ID: <4D73C4EC.7090702@lwfinger.net>
Date: Sun, 06 Mar 2011 11:31:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Ruijl <benruyl@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u: packet loss
References: <AANLkTi=-KJ+OSvDGuxYvDYQZ2ZdS8G8obbvodOXd9zQD@mail.gmail.com> <AANLkTimTecR-W7iGzRWB_DxNVJoovK5SCuWfCmt8SUJo@mail.gmail.com> <AANLkTimx7=kYdWfe8FKL6oMyErE=3=GpXa-YrxkVVBG3@mail.gmail.com> <4D5AAC7C.6060509@lwfinger.net> <AANLkTikKsjmKeNdi9ugiNX-1W5qBKdxw-KexEYLnZJ1p@mail.gmail.com> <4D5AC011.5050007@lwfinger.net> <AANLkTin8viV=LXfv-ut0+U=Jo0MNCbm0KDE=h8Eaa0MK@mail.gmail.com> <AANLkTikmFj5EDaa3sY6d05XRCKwBWywtMaekmK1hCHPX@mail.gmail.com>
In-Reply-To: <AANLkTikmFj5EDaa3sY6d05XRCKwBWywtMaekmK1hCHPX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2011 03:52 AM, Ben Ruijl wrote:
> Hi Larry,
>
> The iwconfig I sent you is wrong, because I switched routers. The
> router I had was a wireless N router, with which I had 12 percent
> packet loss. The iwconfig you are seeing is with a wireless G
> connection and now I only have 1 percent packet loss: the same as you
> have. It appears that the relative packet loss is greater with an N
> connection.

I have no idea why the loss should be greater with the N router than with the G 
router.

How is the 2.4 GHz part of the N router configured? What make/model is it, and 
what firmware is it running? Do you have the latest version?

My N router is a Netgear WNDR3300 normally running up to 270 Mbps at 5 GHz and 
54 Mbps at 2.4 GHz; however, I changed it to run up to 270 Mbps in the 2.4 GHz 
band. Again, I get 1% ping loss. My iwconfig output is

wlan12    IEEE 802.11bgn  ESSID:"lwfdjf-n"  Nickname:"rtl_wifi"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate:270 Mb/s   Sensitivity:0/0
           Retry:off   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=97/100  Signal level=100/100  Noise level=0/100
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


That link gets an upload speed measured with tcpperf of more than 80 Mbps.

I do not know why your N link is so lossy. The possible reasons are outdated 
firmware in the router that was established in the pre-N days, or you have 
noise/interference that affects the HT setup more than a simple G configuration.

Larry
