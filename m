Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38027 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681AbcAZImI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 03:42:08 -0500
Message-ID: <1453797724.2759.4.camel@sipsolutions.net> (sfid-20160126_094225_772889_A4D7E381)
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties with
 rfkill_gpio
From: Johannes Berg <johannes@sipsolutions.net>
To: Thierry Reding <thierry.reding@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Marc Dietrich <marvin24@gmx.de>
Date: Tue, 26 Jan 2016 09:42:04 +0100
In-Reply-To: <20160125121840.GA20452@ulmo.nvidia.com> (sfid-20160125_131846_334590_41466BBA)
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1453712629-143317-4-git-send-email-heikki.krogerus@linux.intel.com>
	 <20160125121840.GA20452@ulmo.nvidia.com>
	 (sfid-20160125_131846_334590_41466BBA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-25 at 13:18 +0100, Thierry Reding wrote:
> 
> Johannes, I assume that you'll want to take this through your tree
> because of the dependency? In that case:
> 
> Acked-by: Thierry Reding <treding@nvidia.com>

I can, but I don't really care - perhaps you'd rather take the entire
series through your tree to get it into one place for Marc?

In which case, you have my

Acked-by: Johannes Berg <johannes@sipsolutions.net>

for the other 3 patches.

Let me know which you prefer.

johannes
