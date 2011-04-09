Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1643 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1DINWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 09:22:50 -0400
Date: Sat, 9 Apr 2011 09:22:46 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Eugene A. Shatokhin" <dame_eugene@mail.ru>,
	Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: improve pcal error handling for ENOMEM case
Message-ID: <20110409132246.GD18154@hash.lan>
References: <1302291192-19249-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302291192-19249-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 08, 2011 at 03:33:12PM -0400, John W. Linville wrote:
> The ath5k driver does kmalloc allocations for pcal info in a loop.
> But, if one fails it was simply returning -ENOMEM without freeing
> already allocated memory.  This patch corrects that oversight.
> 
> Reported-by: Eugene A. Shatokhin <dame_eugene@mail.ru>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Reviewed-by: Bob Copeland <me@bobcopeland.com>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com

