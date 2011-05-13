Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab1EMNmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:42:45 -0400
Subject: Re: concurrency advertising -- driver maintainers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sujith <Sujith.Manoharan@atheros.com>
In-Reply-To: <1305290657.3487.32.camel@jlt3.sipsolutions.net> (sfid-20110513_144426_187099_CDAFE5E0)
References: <1305290657.3487.32.camel@jlt3.sipsolutions.net>
	 (sfid-20110513_144426_187099_CDAFE5E0)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:40:52 +0200
Message-ID: <1305294053.3487.37.camel@jlt3.sipsolutions.net> (sfid-20110513_154249_292501_6B35F214)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 14:44 +0200, Johannes Berg wrote:

> The affected drivers, as far as I can tell, are:

I forgot ath9k_htc, which needs to advertise something afaict (two
interfaces seem to be supported)

johannes

