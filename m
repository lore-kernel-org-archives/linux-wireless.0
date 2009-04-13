Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hell.pl ([193.219.28.162]:46874 "EHLO hell.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZDMQYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:24:41 -0400
Date: Mon, 13 Apr 2009 18:24:39 +0200
From: Grzegorz Nowakowski <krecik@hell.pl>
To: Tony Vroon <tony@vroon.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k blind to nearby network
Message-ID: <20090413162439.GA30220@hell.pl> (sfid-20090413_182444_341289_82BAAF61)
References: <20090410213958.GA12571@hell.pl> <20090411171955.76c48709@vroon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090411171955.76c48709@vroon.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 11, 2009 at 05:19:55PM +0100, Tony Vroon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On Fri, 10 Apr 2009 23:39:58 +0200
> Grzegorz Nowakowski <krecik@hell.pl> wrote:
> > The symptom is that with both NetworkManager and WICD (and "iwlist
> > <if> scanning") I don't see my home network on the list.  I see all
> > other neighbouring networks around and I'm even able to connect if
> > any is open.
> 
> Please doublecheck your wireless regulatory setting. On the default
> "world" domain, it is unlikely you will be able to see networks on
> channel 13. You may well have chosen that specific channel because it
> was so quiet.

Gee, that was so stoopid!  You have guessed correctly, the channel in
use was indeed thirteenth and 13 was its number.  After reconfiguring
the AP to use another one everything seems to be working fine.

But that leaves me with the question: why Windows XP on Atheros and Linux
on Intel didn't have such trouble?

Anyway, thanks for suggestion and best regards.
-- 
Grzegorz Nowakowski
