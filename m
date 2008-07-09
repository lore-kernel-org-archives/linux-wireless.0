Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24888 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYGIC4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 22:56:32 -0400
Message-ID: <20080708225632.lslid0rl5w4k40s8-cebfxv@webmail.spamcop.net> (sfid-20080709_045636_500706_41C70312)
Date: Tue, 08 Jul 2008 22:56:32 -0400
From: Pavel Roskin <proski@gnu.org>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br, wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] rtl8187: Adding Realtek rtl8187B support
References: <3ace41890807080412w3f24a8c1wa2665d8d6de785c9@mail.gmail.com>
	<48736E18.5060708@lwfinger.net> <20080708140457.GA10361@tuxdriver.com>
	<3ace41890807080924t6e7123bbk344cb236e43e1b2e@mail.gmail.com>
	<20080708190234.GC30833@tuxdriver.com>
	<3ace41890807081356uf6acaua6c94483e5e50a67@mail.gmail.com>
In-Reply-To: <3ace41890807081356uf6acaua6c94483e5e50a67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Hin-Tak Leung <hintak.leung@gmail.com>:

> On Tue, Jul 8, 2008 at 8:02 PM, John W. Linville   
> <linville@tuxdriver.com> wrote:
> <snipped>
>> It looks better, although FWIW I was able to fix-up the 2nd round by
>> hand without much problems. :-)
>
> Wow, you have already committed to wireless-testing... that means it
> will be on fedora 9 soon :-).

I've tested the latest wireless-testing.  It's working with both  
rtl8187 and 8187b, which is great!

The time of bringing the interface up are significant in both cases:  
7.5 seconds for rtl8187 and 15 seconds for rtl8187b.

I was able to connect to a WPA2 enabled AP with both devices.   
Unfortunately, I've seen the same problem with both devices.  If  
wpa_supplicant is running, there is a 50% probability that it would  
fail to connect initially, and all further scans will come empty.   
I've seen a similar problem with a PCI based rtl8185, although it was  
less likely.

Anyway, both rtl8187 and rtl8187b are working equally well, except  
that the startup time is twice as long for rtl8187b.

-- 
Regards,
Pavel Roskin
