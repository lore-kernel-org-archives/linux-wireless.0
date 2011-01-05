Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web31507.mail.mud.yahoo.com ([68.142.198.136]:38435 "HELO
	web31507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010Ab1AEB24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 20:28:56 -0500
Message-ID: <512985.80004.qm@web31507.mail.mud.yahoo.com>
Date: Tue, 4 Jan 2011 17:28:54 -0800 (PST)
From: Ming-Ching Tiew <mctiew@yahoo.com>
Subject: Re: Tp-link wn7200nd - cannot associate
To: Chin Shi Hong <cshong87@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201101041742.28794.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Tue, 1/4/11, Helmut Schaa <helmut.schaa@googlemail.com> wrote:

> Chin Shi Hong:
> > Good luck with you. My rt3090 also not work on 64 bit
> ubuntu but work
> > on 32 bit ubuntu.
> 
> Might be fixed with [1].
> 
> Helmut
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=412b31334b831a8c2909afaca017c5a236ac2dd0
> --

I am not using it on a 64 bit system. I have found out that for my case, it is not totally cannot associate. It's able to associate, but it breaks quite easily and it has great difficulty in establishing the association. 

I am pretty sure it's a different problem from the 64bit thingie.

My notebook does have a built-in intel board using iwlagn. It is able to associate even when the network-manager is showing 2 bars of signal. Whereas using using wn7200nd, the network-manager is showing FULL 4 bars of signal, yet it has great difficulty in establishing association and after association, it breaks away from that easily.

I will try to loan a powered usb hub to see it makes any difference. 

Regards.


      
