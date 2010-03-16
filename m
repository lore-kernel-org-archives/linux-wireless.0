Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3680 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936952Ab0CPMNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 08:13:32 -0400
Date: Tue, 16 Mar 2010 08:12:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Blaich <ablaich@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] ath5k: retries in ath5k_hw_setup_4word_tx_desc
Message-ID: <20100316121245.GC27463@hash.localnet>
References: <6b5e31691003151300h1ab71850g695cbec6cdbaa0a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6b5e31691003151300h1ab71850g695cbec6cdbaa0a0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 04:00:49PM -0400, Andrew Blaich wrote:
> Removing AR5K_TUNE_HWTXTRIES from the Ath5k code, it adds 4
> retries to tx_tries0.  By removing AR5K_TUNE_HWTXTRIES, the rate
> control algorithm is given full control over the retry count.
> 
> Signed-off-by:: Andrew Blaich <ablaich@gmail.com>

I believe John has already picked up the patch into wireless-testing.

Thanks for the submission!
-- 
Bob Copeland %% www.bobcopeland.com

