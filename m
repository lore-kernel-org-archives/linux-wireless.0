Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45378 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab1CRNGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 09:06:40 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Q0ZNx-00009A-4O
	for linux-wireless@vger.kernel.org; Fri, 18 Mar 2011 14:06:33 +0100
Received: from 212.44.20.129.ip.redstone-isp.net ([212.44.20.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 14:06:33 +0100
Received: from arend by 212.44.20.129.ip.redstone-isp.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 14:06:33 +0100
To: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend@broadcom.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
Date: Fri, 18 Mar 2011 13:06:20 +0000 (UTC)
Message-ID: <loom.20110318T135709-526@post.gmane.org>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@...> writes:

> 
> Signed-off-by: Rafał Miłecki <zajec5@...>
> ---
> To keep ssb clean and avoid bigger code duplications, my idea is to:
> 1) Rename ssb directory to bcmb (like Broadcom's bus)
> 2) Have two *separated* drivers in it: ssb and ai
> 3) Share common function between ssb and ai

Hi Rafał,

I have been tinkering on our brcm80211 ai functions and separated the
ai_scan and some general AMBA AXI functions in a library module named
brcmaxi. I was having this reviewed internally before submitting it.
This may have a large overlap to what you have been doing. I will take
a look how your work fits in our brcm80211 driver(s).

Gr. AvS


