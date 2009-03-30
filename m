Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50589 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZC3RfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:35:06 -0400
Received: by bwz17 with SMTP id 17so2016713bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 10:35:02 -0700 (PDT)
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 11/17] ath9k: Remove TIM from the interrupt mask
References: <18896.38867.997551.983464@gargle.gargle.HOWL>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 30 Mar 2009 20:35:00 +0300
In-Reply-To: <18896.38867.997551.983464@gargle.gargle.HOWL> (Sujith's message of "Mon\, 30 Mar 2009 15\:28\:43 +0530")
Message-ID: <8763hqnccb.fsf@litku.valot.fi> (sfid-20090330_193510_863915_3304964A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <Sujith.Manoharan@atheros.com> writes:

> -	/*
> -	 * Some hardware processes the TIM IE and fires an
> -	 * interrupt when the TIM bit is set.  For hardware
> -	 * that does, if not overridden by configuration,
> -	 * enable the TIM interrupt when operating as station.
> -	 */

This might be useful for beacon filtering. Does the hardware know to
parse the beacons in more detail, for example ERP protection or WMM
settings?

-- 
Kalle Valo
