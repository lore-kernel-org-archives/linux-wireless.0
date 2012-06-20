Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:40796 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab2FTMWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:22:06 -0400
Message-ID: <4FE1C06A.3060605@neratec.com> (sfid-20120620_142210_577566_A1DB7F3F)
Date: Wed, 20 Jun 2012 14:22:02 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v2 1/7] nl80211/cfg80211: add radar detection command/event
References: <1340111463-4554-1-git-send-email-victorg@ti.com> <1340181600.4655.34.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340181600.4655.34.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2012 10:40 AM, Johannes Berg wrote:
> [...]
> 
> How do you intend to handle HT40?
> 
> johannes
> 

Not to mention VHT ante portas...

We should start with HT20 support only to have something to start
testing with and add HT40 gradually (assuming it will require a lot more
locations to be patched to be available initially).


