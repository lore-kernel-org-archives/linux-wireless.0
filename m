Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43025 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2G1PcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 11:32:18 -0400
Received: by qadb17 with SMTP id b17so263211qad.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 08:32:17 -0700 (PDT)
Message-ID: <501405FA.3070504@lwfinger.net> (sfid-20120728_173253_088439_E20F503E)
Date: Sat, 28 Jul 2012 10:32:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Marco <netuse@lavabit.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187 in master mode with hostapd
References: <20120727171137.4a1d1ce7@homerow>
In-Reply-To: <20120727171137.4a1d1ce7@homerow>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2012 10:11 AM, Marco wrote:
> Hi,
>
> I own an Alfa AWUS036H network adapter using the rtl8187 driver on a
> Debian box running kernel 3.5.0. I want to use it with hostapd, which
> apparently requires master mode to be enabled in the driver.
>
> The page http://linuxwireless.org/en/users/Drivers/rtl8187 states:
>
>    not working yet: AP/Master mode
>
> What means *yet*? Is it planned to add master mode support in the
> near future? Do you have other suggestions what I could do to get
> the driver to work together with hostap?
>
> Disclaimer: I am not an expert in those things. I set up the access
> point some years ago, then the network adapter started to function
> unreliably. I then replaced it with a different one (the
> abovementioned 036H) and didn't manage to get my setup running
> again.

In the case of the RTL8187L, which is the chip in your Alfa device, it means 
*never*. That chip only has a single hardware transmit queue and the work of 
getting the high-priority traffic, such as beacons, transmitted at the correct 
time would be much more than it would be worth.

Sorry,

Larry



