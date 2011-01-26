Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56211 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZRVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 12:21:48 -0500
Received: by iyj18 with SMTP id 18so575334iyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 09:21:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19776.19422.571177.795197@gargle.gargle.HOWL>
References: <19776.19422.571177.795197@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 Jan 2011 09:21:27 -0800
Message-ID: <AANLkTi=881eHyZEHnjY_XkCGLnzNWz1iuUVoJQA_KkAB@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: Fix INI fixup
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith.Manoharan@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 8:29 AM, Sujith <m.sujith@gmail.com> wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>
> Commit "ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c"
> changed the behavior of INI overriding which is needed only
> for PCI cards. Revert to the original check.
>
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>

You leave me no option but to come out of e-mail reply slumber. What
issues was this causing?

  Luis
