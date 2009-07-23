Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:39753 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZGWVvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 17:51:38 -0400
Message-ID: <4A68953E.5090305@lwfinger.net>
Date: Thu, 23 Jul 2009 11:52:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Brian J. Mc Hugh" <bjmchugh@aya.yale.edu>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom b4318 PCI card
References: <a23fe9cc0907231105r1fac505cle28df455b3fb7c55@mail.gmail.com>
In-Reply-To: <a23fe9cc0907231105r1fac505cle28df455b3fb7c55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian J. Mc Hugh wrote:
> Hi Larry,
>  
> I have a Gateway Solo 9300 laptop with a Linksys WiFi card.
>  
> WiFi used to work until I installed the latest stable Debian release (I
> following the directions at
> http://www.linuxwireless.org/en/users/Drivers/b43#fw-b43-new) .
>  
> The card always receives signal from my router (iwlist wlan0 scan) but
> it often fails to transmit signal to the router and I'm unable to
> establish Internet connectivity (ifup wlan0).
>  
> Any clues of how to fix this?

Please post the output of 'dmesg | grep b43'.
