Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:13629 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYB0EEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 23:04:46 -0500
Received: by py-out-1112.google.com with SMTP id u52so3914345pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 20:04:45 -0800 (PST)
Message-ID: <43e72e890802262004v355ff92fj5932852ff8b5296f@mail.gmail.com> (sfid-20080227_040448_803065_BA93279B)
Date: Tue, 26 Feb 2008 23:04:45 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH 5/8] ath5k: Remove RF5413 from rf gain optimization functions
In-Reply-To: <20080224042425.GD4426@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042425.GD4426@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2008 at 11:24 PM, Nick Kossifidis <mick@madwifi.org> wrote:
>
>   * Since RF2413 it seems that RF_BUFFER settings are different (notice
>  that the last part -"bank 7" or whatever- is smaller than in 5111/5112).
>  So until we know what's going on we assume there is no gain optimization
>  stuff in post-5112 chips.
>
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
