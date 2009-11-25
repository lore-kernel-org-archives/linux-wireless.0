Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12830 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbZKYGSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 01:18:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 22:18:44 -0800
Date: Wed, 25 Nov 2009 11:48:35 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Kyungwan Nam <Kyungwan.Nam@Atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Shan Palanisamy <Shan.Palanisamy@Atheros.com>,
	Paul Shaw <Paul.Shaw@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH] ath9k: Fix maximum tx fifo settings for single stream
	devices
Message-ID: <20091125061834.GA27936@vasanth-laptop>
References: <1259116677-2249-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1259116677-2249-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 08:07:57AM +0530, Luis Rodriguez wrote:
> +
> +       if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
> +               pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
> +       else
> +               pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;

I missed this one, thanks.
