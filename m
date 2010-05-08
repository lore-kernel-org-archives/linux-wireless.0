Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2135 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0EHWjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 18:39:05 -0400
Date: Sat, 8 May 2010 18:33:19 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [patch 6/9] ath5k: several off by one range checks
Message-ID: <20100508223319.GA6377@hash.localnet>
References: <20100508162438.GR27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100508162438.GR27064@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 08, 2010 at 06:24:38PM +0200, Dan Carpenter wrote:
> There are several places that use > ARRAY_SIZE() instead of 
> >= ARRAY_SIZE().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks,
Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

