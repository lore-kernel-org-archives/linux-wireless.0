Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633Ab1LOXAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 18:00:36 -0500
Received: by iaeh11 with SMTP id h11so3395191iae.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 15:00:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323989753.1270.19.camel@joe2Laptop>
References: <1323989753.1270.19.camel@joe2Laptop>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 15 Dec 2011 15:00:15 -0800
Message-ID: <CAB=NE6V6AszbNBiMOy4ZacwXqJWeWO0DL3cF_A1E2HVGMicbtA@mail.gmail.com> (sfid-20111216_000039_657539_FE2A5DD5)
Subject: Re: [PATCH wireless-next] ath: Convert ath_dbg(bar, ATH_DBG_<FOO>, to
 ath_dbg(bar, FOO
To: Joe Perches <joe@perches.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 2:55 PM, Joe Perches <joe@perches.com> wrote:
> Add ATH_DBG_ to macros to shorten the uses and
> reduce the line count.
>
> Coalesce ath_dbg formats.
> Add missing spaces to coalesced formats.
> Add missing newline terminations to ath_dbg formats.
> Align ath_dbg arguments where appropriate.
> Standardize ath_dbg formats without periods.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Good idea, are you cocci spatching this? This will obviosly create
conflicts with pending patches.

  Luis
