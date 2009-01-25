Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2253 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZAYV5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 16:57:04 -0500
Date: Sun, 25 Jan 2009 16:56:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: support LED's on emachines E510 notebok
Message-ID: <20090125215646.GA8247@hash.localnet> (sfid-20090125_225712_076061_A6F126CC)
References: <1232914461-19607-1-git-send-email-tuliom@gmail.com> <20090125212044.GA3592@hash.localnet> <d94c510d0901251333u3d5baec5nb0d51977fd82b620@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d94c510d0901251333u3d5baec5nb0d51977fd82b620@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 25, 2009 at 10:33:54PM +0100, Tulio Magno Quites Machado Filho wrote:
> Sorry... I haven't seen that.
> After the changes, should I submit them as a new mail? And to all lists?

Sure, just resend the whole, corrected patch to everyone.  For small 
changes like this, you can make a note of it before the diffstat like
so:

   Signed-off-by: ...
   ---
   
   v2: fixed order of pci_ids.h
   
   drivers/net/wireless/ath5k/base.c |    8 ++++++--
   include/linux/pci_ids.h           |    2 ++
   2 files changed, 8 insertions(+), 2 deletions(-)
   
   diff ...

Anything between that first '---' and the patch gets thrown away when
the patch is applied, but it helps upstream (John) know what changed.

-- 
Bob Copeland %% www.bobcopeland.com

