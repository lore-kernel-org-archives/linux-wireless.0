Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35739 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbZKTBI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 20:08:56 -0500
Date: Thu, 19 Nov 2009 20:04:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Bitterli <Felix.Bitterli@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: master-2009-11-19 busted? can't hold network connection for more
 than 1 second
Message-ID: <20091120010457.GA2633@tuxdriver.com>
References: <1258678718.5323.8.camel@darkslate>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1258678718.5323.8.camel@darkslate>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2009 at 04:58:38PM -0800, Felix Bitterli wrote:
> Hi,
> 
> does anybody else see this?(sorry I can't bisect today, might have time
> tomorrow)
> 
> Wireless testing kernel master-2009-11-19 can't hold a network
> connection for more than 1 second, master-2009-11-18 is fine.
> 
> H/W Thinkpad T43, Atheros AR9280 Rev:2 mem=0xf89e0000, irq=21
> 
> Network office Wpa2/psk, tons of traffic/aps/clients.

Bisect should be pretty easy...? :-)

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
