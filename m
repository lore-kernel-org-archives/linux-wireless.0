Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41309 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab0CSUax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 16:30:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb: do not read SPROM if it does not exist
Date: Fri, 19 Mar 2010 21:30:50 +0100
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org
References: <4BA266FB.1080507@lwfinger.net> <201003192041.47211.mb@bu3sch.de> <20100319202120.GD9552@tuxdriver.com>
In-Reply-To: <20100319202120.GD9552@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003192130.50798.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 March 2010 21:21:21 John W. Linville wrote:
> -       if (bus->chip_rev >= 31)
> +       if (bus->chipco.dev->id.revision >= 31)
> 
> Is that right?

Yeah, that's OK. Same goes for the other revision tests.

-- 
Greetings, Michael.
