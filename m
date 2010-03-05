Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2144 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0CENeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 08:34:19 -0500
Date: Fri, 5 Mar 2010 08:33:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, 8an@praha12.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: [PATCH 1/3] ath5k: fix I/Q calibration (for real)
Message-ID: <20100305133308.GA6261@hash.localnet>
References: <20100305063255.29522.83920.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100305063255.29522.83920.stgit@void>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 05, 2010 at 03:32:55PM +0900, Bruno Randolf wrote:

Um, disregard my mask thing, that was the original bug
(-128 when masked to 6 bits overflows).  Still, we can use:

   i_coff = clamp(i_coff, -32, 31);

-- 
Bob Copeland %% www.bobcopeland.com

