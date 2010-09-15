Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:23923 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0IOS4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 14:56:25 -0400
Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: Shahar Levi <shahar_levi@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284576801.7705.7.camel@jlt3.sipsolutions.net>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
	 <1284575472-19888-5-git-send-email-shahar_levi@ti.com>
	 <1284576801.7705.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 21:56:12 +0300
Message-ID: <1284576972.1569.6.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 20:53 +0200, ext Johannes Berg wrote:
> On Wed, 2010-09-15 at 20:31 +0200, Shahar Levi wrote:
> > Add support to configurable 11n
> 
> This really makes no sense.

Yes, that's true.  In real life it makes no sense, but we required this
temporarily because we want to keep this completely disable until it's
proven to work correctly (and we have tested it more thoroughly).  There
are still a few missing bits in this implementation...


-- 
Cheers,
Luca.

