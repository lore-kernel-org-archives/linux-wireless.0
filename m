Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXH1RNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 13:13:32 -0400
Date: Tue, 28 Aug 2007 18:13:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
Message-ID: <20070828171330.GD29343@infradead.org>
References: <2713029743177393055@pripojeni.net> <280951420471148977@pripojeni.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <280951420471148977@pripojeni.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2007 at 12:01:30PM -0400, Jiri Slaby wrote:
> +config ATH5K_AR5210
> +	bool "Support AR5210"
> +	depends on ATH5K
> +	default y
> +
> +config ATH5K_AR5211
> +	bool "Support AR5211"
> +	depends on ATH5K
> +	default y
> +
> +config ATH5K_AR5212
> +	bool "Support AR5212"
> +	depends on ATH5K
> +	default y

Please don't add more default statements.

Also this whole patch seems rather pointless.  It saves only
very little and turns the driver into a complete ifdef maze.
