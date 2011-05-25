Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134Ab1EYNLt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 09:11:49 -0400
Date: Wed, 25 May 2011 15:11:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110525131130.GA3260@redhat.com> (sfid-20110525_151152_377180_68834ABE)
References: <1306151106.2066.60.camel@x61.thuisdomein>
 <20110524070941.GA2189@redhat.com>
 <1306255853.12267.14.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306255853.12267.14.camel@x61.thuisdomein>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 24, 2011 at 06:50:53PM +0200, Paul Bolle wrote:
> On Tue, 2011-05-24 at 09:09 +0200, Stanislaw Gruszka wrote:
> > What is your configuration (mode,
> > encryption, do you use wpa_supplicant or NetworkManager, which version,
> > etc ...)?
> 
> 0) Mode as is displayed in iwconfig output? That is "Managed".
> 
> 1) Encryption is wep (so, no wpa_supplicant).
> 
> 2) Currently using NetworkManager-0.8.4-1.fc14.x86_64.

I try to use WEP with one AP, no microcode errors. However with different
NetworkManager version, not sure if it is important. I'll try lately on F-14. 
What channel do you use? Is network 11n or 11g or mixed ? WEP is 40 bits or
other?

> > I will try to reproduce locally. If I'll be not able to reproduce,
> > I'll ask you for debug logs on broken, and working (i.e. 2.6.38) version
> > for compare.
> 
> 3) Sure, no problem. But isn't 2.6.38 from before the iwlegacy split?
Yes, it is. If the problem was introduced during driver split (that
happen in 2.6.39), one way to find a fix would be compare driver
behaviour before the split and after.

Stanislaw
