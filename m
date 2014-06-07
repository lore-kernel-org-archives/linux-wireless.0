Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm2-vm6.bullet.mail.sg3.yahoo.com ([106.10.148.109]:20404 "EHLO
	nm2-vm6.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbaFGR7m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 13:59:42 -0400
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net>
Message-ID: <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com> (sfid-20140607_195946_701434_230DB0C0)
Date: Sun, 8 Jun 2014 01:59:40 +0800 (SGT)
From: Powerful Notageek <powerfulnotageek@yahoo.in>
Reply-To: Powerful Notageek <powerfulnotageek@yahoo.in>
Subject: Re: MT7630e availability in kernel by default
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <53935133.5020303@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's lspci -nn

03:00.0 Network controller [0280]: MEDIATEK Corp. MT7630e 802.11bgn Wireless Network Adapter [14c3:7630]

I have tried using the drivers available on RALink/Mediatek on a pretty recent kernel of Fedora20, didn't seem to work. 

Thanks



On Saturday, 7 June 2014 11:21 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
On 06/07/2014 11:38 AM, Powerful Notageek wrote:



> Hello,
>
> I was wondering if anyone here would know when the drivers for this card will be added to the kernel by default.
>
> 03:00.0 Network controller: MEDIATEK Corp. MT7630e 802.11bgn Wireless Network Adapter

Supplying the line from 'lspci -nn' is a lot more helpful than just lspci.

According to the Web, the wireless chip is from Ralink. There is a git repo that 
is supposed to have a driver for the device, but it is full of the standard 
rt2xxx driver files. Perhaps it will work with newer kernels, or by adding the 
PCI ID to an existing driver. In any case, we need the PCI ID.

Larry
