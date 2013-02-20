Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:60227 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756700Ab3BTIPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 03:15:23 -0500
Date: Wed, 20 Feb 2013 09:15:38 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?iso-8859-15?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	David Miller <davem@davemloft.net>, David.Laight@aculab.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, bittorf@bluebottle.com,
	stable@vger.kernel.org, openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
Message-ID: <20130220081538.GO8730@medion.lan> (sfid-20130220_091528_211087_4BB7C810)
References: <20130219.005206.397289032011003833.davem@davemloft.net>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com>
 <5123BCFF.5090408@lwfinger.net>
 <20130219.131553.787630407148880340.davem@davemloft.net>
 <5123C43D.2020602@lwfinger.net>
 <CAGRGNgWZ0qUJSSkjmP8o4VaPRBdN67J=RPy5+45rWaQQXWnWrQ@mail.gmail.com>
 <512437FA.2030105@lwfinger.net>
 <CA+XFjipJHGTvzUx6yy1DTc74kbrPEQxM08zW=N1uf43=Q6pwdg@mail.gmail.com>
 <5124782D.3050803@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <5124782D.3050803@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Larry Finger <Larry.Finger@lwfinger.net> [20.02.2013 08:32]:
> On 02/20/2013 12:26 AM, Gábor Stefanik wrote:
> >
> >Is this an issue that vendor drivers are also vulnerable to? If it is
> >a firmware issue, I would certainly think so.
> 
> I also think so, at least if they are using the firmware version that
> Bastian is using. His logs don't have that info in them, but I
> certainly saw the problem on my BCM4312 using firmware 508.154 from
> 2009.
 
Another test this morning with heavy downloading (but tcp only)
show slot usage auf max 204/256. we are using firmware

"version 666.2 (2011-02-23 01:15:07)" which is OpenWrt's default
for b43. see here the full logs, including minstrel output and dmesg:

http://intercity-vpn.de/files/openwrt/b43test2.dmesg.txt

if a slot needs ~2500 bytes, so 256 slot are only 640kb which seems
ok to me. ofcourse it raises the memory consumption by 500kb, but now
the router is useful 8-)

thank you! bye, bastian

