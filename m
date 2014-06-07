Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:53842 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaFGRvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 13:51:50 -0400
Received: by mail-ob0-f178.google.com with SMTP id wp4so214163obc.9
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 10:51:49 -0700 (PDT)
Message-ID: <53935133.5020303@lwfinger.net> (sfid-20140607_195153_217267_2BF11F10)
Date: Sat, 07 Jun 2014 12:51:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Powerful Notageek <powerfulnotageek@yahoo.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: MT7630e availability in kernel by default
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com>
In-Reply-To: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

