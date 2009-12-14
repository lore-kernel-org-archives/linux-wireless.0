Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46035 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZLNBz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 20:55:29 -0500
Subject: Re: [PATCH 1/2] wireless: support internal statically compiled
 regulatory database
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1260755116-3829-1-git-send-email-linville@tuxdriver.com>
References: <1260755116-3829-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 02:55:19 +0100
Message-Id: <1260755719.4041.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> +config CFG80211_INTERNAL_REGDB
> +	bool "use statically compiled regulatory rules database"
> +	default n
> +	depends on CFG80211
> +	---help---
> +	  This option generates an internal data structure representing
> +	  the wireless regulatory rules described in net/wireless/db.txt
> +	  and includes code to query that database.  This is an alternative
> +	  to using CRDA for defining regulatory rules for the kernel.
> +
> +	  For details see:
> +
> +	  http://wireless.kernel.org/en/developers/Regulatory
> +
> +	  Most distributions have a CRDA package.  So if unsure, say N.

since it is pretty clear that people should be defaulting to CRDA, why
not make it depend on CONFIG_EMBEDDED.

Regards

Marcel


