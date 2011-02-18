Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2465 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1BRS1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 13:27:24 -0500
Date: Fri, 18 Feb 2011 13:27:23 -0500
From: me@bobcopeland.com
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com, jirislaby@gmail.com
Subject: Re: [PATCH] ath5k: Correct channel setting for AR2317 chip
Message-ID: <20110218182723.GF6066@hash.localnet>
References: <20110218195953.cf4e349f.nledovskikh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110218195953.cf4e349f.nledovskikh@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 07:59:53PM +0300, Nikolay Ledovskikh wrote:
> Correct channel setting function must be used for AR2317.
> When I tested ahb patch on bullet2 all seemed to work fine, 
> but it couldn't connect another host (using ibss for example). 
> During an analysis I observed that it's transmitting on another 
> channel. I looked into madwifi code and understood that
> the problem is in channel setting function. So atheros RF2317 not 
> fully handled in the current ath5k version and must be patched.
> 
> Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>

Thanks!

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

