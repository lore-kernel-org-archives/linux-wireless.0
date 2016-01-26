Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38078 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681AbcAZIq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 03:46:59 -0500
Message-ID: <1453798016.2759.5.camel@sipsolutions.net> (sfid-20160126_094721_945579_65FE5ABF)
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties
 withrfkill_gpio
From: Johannes Berg <johannes@sipsolutions.net>
To: Marc Dietrich <marvin24@gmx.de>,
	Thierry Reding <thierry.reding@gmail.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>
Date: Tue, 26 Jan 2016 09:46:56 +0100
In-Reply-To: <1626364.s6q6eBGYVQ@ax5200p> (sfid-20160125_220148_930415_998CEFCC)
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1453712629-143317-4-git-send-email-heikki.krogerus@linux.intel.com>
	 <20160125121840.GA20452@ulmo.nvidia.com> <1626364.s6q6eBGYVQ@ax5200p>
	 (sfid-20160125_220148_930415_998CEFCC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-25 at 21:59 +0100, Marc Dietrich wrote:
> 
> seems to work fine. I wish we could instantiate this from device-tree 
> so we can finially get rid of this file.

That'd be nice - anyone want to propose rfkill DT bindings? :)

johannes
