Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:65086 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYB0D6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 22:58:19 -0500
Received: by wx-out-0506.google.com with SMTP id h31so2554626wxd.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 19:58:19 -0800 (PST)
Message-ID: <43e72e890802261958k1a586987rd4b21fdc7795f10d@mail.gmail.com> (sfid-20080227_035822_634174_666A3B94)
Date: Tue, 26 Feb 2008 22:58:17 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH 4/8] ath5k: more RF2413 stuff
In-Reply-To: <20080224042115.GC4426@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042115.GC4426@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2008 at 11:21 PM, Nick Kossifidis <mick@madwifi.org> wrote:
>  * Add AR5K_RF2413 to radio check during hw_reset so it doesn't complain
>
>   * Write ah_phy_spending value we set during attach instead of checking
>  each time for radio revision
>
>   * Skip txpower setup for RF2413 because it can't transmit with it
>  (weird thing is that RF5413 has no problem with it).
>
>
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Please run through checkpatch.pl.

  Luis
