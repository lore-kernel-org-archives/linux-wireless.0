Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout04.plus.net ([212.159.14.19]:45379 "EHLO
	avasout04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761541Ab3EAPzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:55:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 01 May 2013 16:55:18 +0100
From: Gerry Gavigan <gerry@gavigan.f9.co.uk>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Sujith Manoharan <sujith@msujith.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath9k problems on openSUSE 12.3
In-Reply-To: <CAJ-Vmon9uK52yJDWCEpCwffnL90S0MVdZWdVGivLEymTWSrFtg@mail.gmail.com>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
 <2687000.szPz826eEU@linux-zd5t.site>
 <20854.23253.514263.467205@gargle.gargle.HOWL>
 <1835202.Vr0lTLYE3Q@linux-zd5t.site>
 <CAJ-Vmon9uK52yJDWCEpCwffnL90S0MVdZWdVGivLEymTWSrFtg@mail.gmail.com>
Message-ID: <dbd61eaa1560cbc7d0e603cf77e04aa4@imap.force9.net> (sfid-20130501_175527_689465_E805BABB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01.05.2013 16:38, Adrian Chadd wrote:
> .. what was the problem?

I had connected a wifi network extender which borked (at the same time 
that I upgraded the kernel for better gma500 support)

I removed the wifi extender but subsequently had all the problems.

However the source was a tick box in my Netgear router that I don't 
remember setting (or it gets set by using an extender, I've not explored 
that)

This provided wirelss isolation limited to the extender and prevented 
authentication directly with the router. (This might be how extenders 
work but that seems strange to me)

I identified it after I dug out a slow but known working AAO with an 
Intel wifi card and which mysteriously failed to authenticate, so from 
then I knew I was looking in the wrong place.
