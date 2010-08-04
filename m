Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41030 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab0HDN7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 09:59:41 -0400
Date: Wed, 4 Aug 2010 09:49:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: WARNING at net/wireless/reg.c when wireless network is
 disconnected
Message-ID: <20100804134908.GB17666@tuxdriver.com>
References: <4C5950B7.4000802@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4C5950B7.4000802@archlinux.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 04, 2010 at 01:36:23PM +0200, Thomas Bächler wrote:
> Hello,
> 
> this warning has been around ever since I switched to 2.6.34, has
> accompanied me through the 2.6.35-rc* phase and is still there with
> 2.6.35. I didn't bother to report it so far, as there seems to be no harm.
> 
> Whenever I disconnect/get disconnected from the wireless, I receive the
> below warning:
> 
> ------------[ cut here ]------------
> WARNING: at net/wireless/reg.c:272
> regulatory_hint_disconnect+0x1b3/0x230 [cfg80211]()
> Hardware name: TECRA A11
> Unexpected user alpha2: de

Perhaps you need to set the regdomain as "DE" rather than "de"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
