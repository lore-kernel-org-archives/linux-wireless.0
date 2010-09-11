Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3716 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0IKRfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 13:35:47 -0400
Date: Sat, 11 Sep 2010 13:31:42 -0400
From: bob@bobcopeland.com
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Subject: Re: [PATCH 0/8] ath: Move key cache functions to ath common
Message-ID: <20100911173142.GI20385@hash.localnet>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 08, 2010 at 04:04:28PM +0900, Bruno Randolf wrote:
> The following series moves the key cache management functions from ath9k to
> the common ath/key.c so we can also use them from ath5k. Both ath5k and
> ath9k are changed to use the common key functions.

Nice, I always wanted us to do this :) ... looks good.

-- 
Bob Copeland %% www.bobcopeland.com

