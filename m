Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout07.plus.net ([84.93.230.235]:34156 "EHLO
	avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3EAIfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 04:35:15 -0400
From: Gerry Gavigan <gerry@gavigan.f9.co.uk>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k problems on openSUSE 12.3
Date: Wed, 01 May 2013 09:35:10 +0100
Message-ID: <1835202.Vr0lTLYE3Q@linux-zd5t.site> (sfid-20130501_103522_007634_1CF84971)
In-Reply-To: <20854.23253.514263.467205@gargle.gargle.HOWL>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net> <2687000.szPz826eEU@linux-zd5t.site> <20854.23253.514263.467205@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 Apr 2013 15:26:37 Sujith Manoharan wrote:
> Gerry Gavigan wrote:
> > - turned power save off
> > - confirmed
> > - shut down
> > - restarted
> > - power save is on
> > 
> > problem persists
> 
> Ok.
> 
> Can you load the driver with more debugging options and post the kernel log
> ? Please use the mask debug=0x8f49.

I managed to identify what turned out to be the real problem.  It was nothing 
to do with the ath9k and everything to do with my router.

I apologise for wasting your time but I am grateful that you bothered

Gerry






