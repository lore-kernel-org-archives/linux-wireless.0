Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:50181 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZHDPZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:25:10 -0400
Received: by gxk9 with SMTP id 9so6923716gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 08:25:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090731183132.GG7963@makis>
References: <20090731180556.GC7963@makis> <20090731183132.GG7963@makis>
Date: Tue, 4 Aug 2009 11:25:09 -0400
Message-ID: <b6c5339f0908040825u294d6ec4s117d9fce52e78537@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: Linear PCDAC code fixes
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 2:31 PM, Nick
Kossifidis<mick@madwifi-project.org> wrote:
>  * Set correct xpd curve indices for high/low gain curves during
>   rfbuffer setup on RF5112B with both calibration curves available.
>
>  * Don't return zero min power when we have the same pcdac value
>   twice because it breaks interpolation. Instead return the right
>   x barrier as we do when we have equal power levels for 2 different
>   pcdac values.
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
