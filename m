Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4483 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0IQERx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 00:17:53 -0400
Date: Fri, 17 Sep 2010 00:14:50 -0400
From: me@bobcopeland.com
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH v2] ath5k: reorder base.c to remove fwd decls
Message-ID: <20100917041450.GA310@hash.localnet>
References: <20100917034507.16135.61268.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100917034507.16135.61268.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 12:45:07PM +0900, Bruno Randolf wrote:
> From: Bob Copeland <me@bobcopeland.com>
> 
> This change reorganizes the main ath5k file in order to re-group
> related functions and remove most of the forward declarations
> (from 61 down to 3).  This is, unfortunately, a lot of churn, but
> there should be no functional changes.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Applies cleanly and builds without warnings, thanks!

-- 
Bob Copeland %% www.bobcopeland.com

