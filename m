Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:54982 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760391AbYGUFM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 01:12:59 -0400
Message-ID: <1542.217.24.1.226.1216617177.squirrel@webmail.madwifi.org> (sfid-20080721_071304_721873_32A8D0F1)
In-Reply-To: <20080720024554.GS17936@ruslug.rutgers.edu>
References: <20080720024341.GQ17936@ruslug.rutgers.edu>
    <20080720024500.GR17936@ruslug.rutgers.edu>
    <20080720024554.GS17936@ruslug.rutgers.edu>
Date: Mon, 21 Jul 2008 07:12:57 +0200 (CEST)
Subject: Re: [PATCH] [PATCH 2/4] Remove Atheros 11n devices from ath5k
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

Luis R. Rodriguez wrote:
> Remove Atheros 11n devices from being claimed by ath5k as its
> now handled by ath9k.

I must admit that I can't tell it myself due to a lack of in-depth
knowledge about both drivers, hence the question: why a new driver, rather
than adding 11n support to ath5k and have a single driver for all Atheros
chipsets?

Bye, Mike
