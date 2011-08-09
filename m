Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail01.spothost.nl ([77.74.49.150]:48939 "EHLO
	webmail01.spothost.nl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752438Ab1HILH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:07:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 09 Aug 2011 11:07:56 +0000
From: kc@cobradevil.org
To: <linux-wireless@vger.kernel.org>
Cc: <kc@cobradevil.org>
Subject: Re: rtl8192cu sometimes it can authenticate to ap
In-Reply-To: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org>
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org>
Message-ID: <34676454425401d650be733a43191a53@cobradevil.org> (sfid-20110809_130801_644826_409C38E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Have installed natty and also installed the snapshot.

After compile and installed the rtlwifi driver the wpa_supplicant works 
like a charm every time with all three sticks.
So i think it is something in the compat layer or userland utilities?

Anyone an idea?
I would like this to work with the maverick kernel 2.6.35 because we 
cannot upgrade right now.

With kind regards

William

On Tue, 09 Aug 2011 09:16:12 +0000, kc@cobradevil.org wrote:

> Hello all,
>
> i have three usb sticks with the the id:
> 0bda:8176
>
> I am running ubuntu maverick with the compat tree from 2011-08-08
> (downloaded this morning) and i also tried several others (dates from 
> 15
> juli 2011).
> The main problem is that sometimes i get a connection and it works 
> like
> a charm and then all of the sudden i don't get any connection at all 
> and
> running wpa_supplicant says time out.
>
> i really have no idea whats wrong so if someone could help me out.
> is there a way to get debugging from the rtlwifi drivers?
>
> i got the firmware from:
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git 
> [1]
>
> With kind regards
>
> William


Links:
------
[1] http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
