Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:42247 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbYEMARi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 20:17:38 -0400
Date: Mon, 12 May 2008 20:17:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k: Fix loop variable initializations
Message-ID: <20080513001726.GA23128@hash.localnet> (sfid-20080513_021744_891689_48DFCE6E)
References: <E1JvZ2x-0005kb-TH@hash.localnet> <40f31dec0805121618j4a2f8bedw78e2ce36d8158649@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0805121618j4a2f8bedw78e2ce36d8158649@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 02:18:48AM +0300, Nick Kossifidis wrote:
> Why not doing a simple
> rxs.flag = 0 ;
> or a check of flags set by mac80211 at the start of the loop ?

Yeah that's a better idea.  I'll respin the patch with this and the
other suggestion.

-- 
Bob Copeland %% www.bobcopeland.com 

