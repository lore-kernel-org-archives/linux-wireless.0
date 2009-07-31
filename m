Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:42001 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZGaSHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:07:33 -0400
Received: by yxe5 with SMTP id 5so258069yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:07:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090731180556.GC7963@makis>
References: <20090731180556.GC7963@makis>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 11:07:12 -0700
Message-ID: <43e72e890907311107h56add3d9i9d7e825f55c8c40d@mail.gmail.com>
Subject: Re: [PATCH 2/4] ath5k: Linear PCDAC code fixes
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:05 AM, Nick
Kossifidis<mick@madwifi-project.org> wrote:
>  * Set correct xpd curve indices for high/low gain curves during
>   rfbuffer setup on RF5112B with both calibration curves available.
>
>  * Don't return zero min power when we have the same pcdac value
>   twice because it breaks interpolation. Instead return the right
>   x barrier as we do when we have equal power levels for 2 different
>   pcdac values.
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)

Missing SOB

  Luis
