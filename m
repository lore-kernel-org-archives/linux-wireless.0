Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1CFJxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 04:53:03 -0500
Received: by fxm17 with SMTP id 17so3315948fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 01:53:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin8viV=LXfv-ut0+U=Jo0MNCbm0KDE=h8Eaa0MK@mail.gmail.com>
References: <AANLkTi=-KJ+OSvDGuxYvDYQZ2ZdS8G8obbvodOXd9zQD@mail.gmail.com>
 <AANLkTimTecR-W7iGzRWB_DxNVJoovK5SCuWfCmt8SUJo@mail.gmail.com>
 <AANLkTimx7=kYdWfe8FKL6oMyErE=3=GpXa-YrxkVVBG3@mail.gmail.com>
 <4D5AAC7C.6060509@lwfinger.net> <AANLkTikKsjmKeNdi9ugiNX-1W5qBKdxw-KexEYLnZJ1p@mail.gmail.com>
 <4D5AC011.5050007@lwfinger.net> <AANLkTin8viV=LXfv-ut0+U=Jo0MNCbm0KDE=h8Eaa0MK@mail.gmail.com>
From: Ben Ruijl <benruyl@gmail.com>
Date: Sun, 6 Mar 2011 10:52:42 +0100
Message-ID: <AANLkTikmFj5EDaa3sY6d05XRCKwBWywtMaekmK1hCHPX@mail.gmail.com>
Subject: Re: r8712u: packet loss
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

The iwconfig I sent you is wrong, because I switched routers. The
router I had was a wireless N router, with which I had 12 percent
packet loss. The iwconfig you are seeing is with a wireless G
connection and now I only have 1 percent packet loss: the same as you
have. It appears that the relative packet loss is greater with an N
connection.

Ben

2011/2/18 Ben Ruijl <benruyl@gmail.com>:
> Here is the output of iwconfig:
>
> wlan0     IEEE 802.11bg  ESSID:"H23"  Nickname:"rtl_wifi"
>          Mode:Managed  Frequency:2.452 GHz  Access Point: 00:23:54:A6:EF:A4
>          Bit Rate:54 Mb/s   Sensitivity:0/0
>          Retry:off   RTS thr:off   Fragment thr:off
>          Power Management:off
>          Link Quality=100/100  Signal level=69/100  Noise level=0/100
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> The link quality varies between 99 and 100, but is almost always 100.
> The signal level varies between 62 and 69.
>
> Ben
>



-- 
Ben Ruijl
PGP 825472FC
