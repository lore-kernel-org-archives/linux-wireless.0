Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:5937 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbYB0EDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 23:03:01 -0500
Received: by wx-out-0506.google.com with SMTP id h31so2556649wxd.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 20:03:01 -0800 (PST)
Message-ID: <43e72e890802262002m5274e417lbbd23f64980aa8d2@mail.gmail.com> (sfid-20080227_040333_143151_0ED5D69E)
Date: Tue, 26 Feb 2008 23:02:59 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH 3/8] ath5k: Identify RF2413 and deal with PHY_SPENDING
In-Reply-To: <20080224041908.GB4426@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224041908.GB4426@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2008 at 11:19 PM, Nick Kossifidis <mick@madwifi.org> wrote:
>  * Attach RF2413.
>
>   * Propertly handle different AR5K_PHY_SPENDING settings for each RF
>  chip by adding a field in ath5k_hw. This way we won't have to check
>  inside hw_reset (see next patch).
>
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Please run through checkpatch first. BTW do we know what this
AR5K_PHY_SPENDING is for?

  Luis
