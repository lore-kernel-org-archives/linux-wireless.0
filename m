Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34903 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbcBWUjJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 15:39:09 -0500
Message-ID: <1456259945.9910.25.camel@sipsolutions.net> (sfid-20160223_213931_585932_5C2AE02A)
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties with
 rfkill_gpio
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>, Marc Dietrich <marvin24@gmx.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>
Date: Tue, 23 Feb 2016 21:39:05 +0100
In-Reply-To: <3466361.DVRahbqhfF@wuerfel>
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <2463567.tt0f0ingYr@wuerfel> <2927215.6IlWnjRTgT@fb07-iapwap2>
	 <3466361.DVRahbqhfF@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 16:06 +0100, Arnd Bergmann wrote:
> 
> Does rfkill always have a separate device in the Linux driver model?

Yes, the rfkill core code registers and adds one in the rfkill class.

> johannes
