Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47480 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2B2XwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 18:52:17 -0500
Received: by wgbds10 with SMTP id ds10so691754wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 15:52:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4E9A36.2080809@lacto.se>
References: <4F4E9A36.2080809@lacto.se>
Date: Wed, 29 Feb 2012 15:52:15 -0800
Message-ID: <CAJ-Vmo=XqnFoiV6rZraWy3nW1vq8ej+DOHkfM7yS3KAepMu6Rg@mail.gmail.com> (sfid-20120301_005220_886878_AB06C7CE)
Subject: Re: "Failed to stop Tx DMA" and "Could not stop RX" with AR9485
From: Adrian Chadd <adrian@freebsd.org>
To: =?ISO-8859-1?Q?Kim_Lidstr=F6m?= <dexter@lacto.se>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I don't recall _how_ to do this, but would you mind verifying whether
you're actually somehow using power saving modes or not?

Thanks,



Adrian
