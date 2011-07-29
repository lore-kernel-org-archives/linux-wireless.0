Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18354 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1G2DMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 23:12:37 -0400
Message-ID: <4E322518.9060209@gnu.org> (sfid-20110729_051247_618265_172A6F76)
Date: Thu, 28 Jul 2011 23:12:24 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Martin Partridge <martin_partridge@btconnect.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: help
References: <op.vzcrpnuuhgplxr@melanie>
In-Reply-To: <op.vzcrpnuuhgplxr@melanie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Please use meaningful subjects for the list posts.

On 07/28/2011 07:33 PM, Martin Partridge wrote:
>
> I don't understand the last 2 steps, i'm running fedora (ok i lie its
> Fuduntu, but to all intents and purposes its fedora) Kernel version:
> 2.6.39.3-1.fc14.i686

Please always give information about the location of the documentation 
if you have any problems with it.

> Enabling p54
>
> To enable p54, you must first enable mac80211:

I used Google and found this text on the linux-wireless wiki:
http://linuxwireless.org/en/users/Drivers/p54

I rephrased the text to make it more clear that it only applied to 
configuring the kernel.

Since you are using a precompiled kernel, you don't have that option.

> I have a kernel config
> file in /etc/sysconfig but its a bit bare, as shown below:

That's something totally different.  The wiki talks about compile-time 
configuration.

> How do i enable p54 and mac80211, i'm not sure and its bloody annoying.

You only need to check if the modules are present in the kernel you are 
using.  You can do that by running "modprobe p54".

-- 
Regards,
Pavel Roskin
