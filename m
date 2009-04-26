Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3681 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZDZCBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 22:01:24 -0400
Date: Sat, 25 Apr 2009 22:00:47 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
Message-ID: <20090426020047.GA10885@hash.localnet> (sfid-20090426_040133_283527_67FD4FBA)
References: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 25, 2009 at 02:09:23PM +0200, Jiri Slaby wrote:
> Hi guys,
> do you remember some 5211 HW which didn't work with this?
> --
> 
> Set null key type even on ar5211, otherwise it en/decrypts every frame with
> protected bit set which renders the card unusable on encrypted networks.

Not me.  I don't have the hardware, so I would say if your patch is known
to work on a 5211 then we go with it.

-- 
Bob Copeland %% www.bobcopeland.com

