Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:39548
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbXKTPkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 10:40:12 -0500
Message-ID: <4742FE36.2090108@roinet.com> (sfid-20071120_154019_646412_745FFB46)
Date: Tue, 20 Nov 2007 10:33:10 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath5k driver on MIPS and low level control over the hw
References: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it>
In-Reply-To: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco Gringoli wrote:
> Hello everybody,
> 
> I have now a few questions
> 
> I would like also to report that I did a very simple test connecting a 
> couple of Atheros card with a coaxial cable (impedances adapted and both 
> systems are connected to the same ground). The two PCs involved are 
> running x86 Linux 2.6.24-rc2 when using ath5k and Linux 2.6.23 when 
> using standard Madwifi code. I see that independently of the channel 
> rate (from 1Mb/s to 54Mb/s) I always get better performances with 
> standard Madwifi code. Could this depend on how queues are handled on 
> the ath5k code?

Madwifi may have some of their superg features on like fast frames, compression, turbo mode etc. http://www.super-g.com/ .

-Ack
