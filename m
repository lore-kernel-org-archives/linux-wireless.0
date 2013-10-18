Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51397 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3JRFaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 01:30:04 -0400
Received: from [192.168.0.100] ([93.218.112.150]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0M4nM5-1VwQfn1M2H-00ywRt for
 <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 07:30:02 +0200
Message-ID: <5260C759.6000801@rempel-privat.de> (sfid-20131018_073034_220417_9D7EA3BF)
Date: Fri, 18 Oct 2013 07:30:01 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIE1hcnRpbnM=?= <sna7e_7@hotmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RTL8723AE] Driver problems
References: <BLU0-SMTP28669C5469915F5D8D155AF89060@phx.gbl>
In-Reply-To: <BLU0-SMTP28669C5469915F5D8D155AF89060@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.10.2013 02:55, schrieb André Martins:
> Hi!
> This is a copy I've sent to Larry Finger and his bot told me to sent to
> this e-mail address instead.
> Basically I've bought a computer with the 8723ae card and unfortunately the
> wireless connection is really bad. Although I'm a last year student on
> MSc in
> computers and telematics engineering I don't have any skills what so
> ever on
> kernel's source code. Thus, I want to ask you if you could help me out
> and tell
> me where to begin to fix this and create a great rtl8723ae driver for
> Linux. I
> could help you with the tests what whatever I could. The main problem
> with this
> card is the connection on my university, it's always dropping and
> impossible to
> have a stable connection. On my house I'm a few meters way of my AP and
> the link
> quality is either on 38/70 or 70/70.
> Since you take the time to read this e-mail I thank you already.
> Thanks,
> André Martins

Hi André,

start with googling for "linux wlan troubleshooting".
Use latest kernel wifi source code:
https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/

If you can compile kernel by your self, then you can do some changes on
kernel. See how driver works, add "printk("%s:%i\ņ", __func__,
__LINE__);" every where and monitore dmesg. The driver is located here:
linux/drivers/net/wireless/rtlwifi/rtl8723ae

If you wont to help with this driver, do not fear to brake you kernel ;)
-- 
Regards,
Oleksij
