Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42965 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbYLXKHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 05:07:46 -0500
Date: Wed, 24 Dec 2008 12:07:41 +0200
From: Jouni Malinen <j@w1.fi>
To: "W. van den Akker" <listsrv@wilsoft.nl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Message-ID: <20081224100741.GA30523@jm.kir.nu> (sfid-20081224_110821_061759_7FEC4613)
References: <200812241040.39056.listsrv@wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812241040.39056.listsrv@wilsoft.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2008 at 10:40:38AM +0100, W. van den Akker wrote:

> I have tested with the latest kernel 2.6.27.10 and compat-wireless 22-12-2008.
> I have a dual core system (Intel(R) Pentium(R) 4 CPU 3.00GHz) and use hostapd 
> 0.6.6.

I've never tested this with compat-wireless, but the wireless-testing
version seems to be working fine in my tests.

> I have build the kernel, compiled the compat-wireless and did a make install.
> Make unload didnt work because some drivers were in use (mac80211).
> First problem arises, a rmmod ath9k hangs the kernel. No message of what so 
> ever in the log or to stdout.

Would you happen to have another host available for storing the logs? I
have been able to receive debug messages from most crashes with
netconsole (see Documentation/networking/netconsole.txt).

-- 
Jouni Malinen                                            PGP id EFC895FA
