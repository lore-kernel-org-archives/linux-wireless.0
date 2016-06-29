Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50481 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbcF2HUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 03:20:35 -0400
Message-ID: <1467184830.2461.6.camel@sipsolutions.net> (sfid-20160629_092057_798615_78ABDC8D)
Subject: Re: [PATCH] mac80211: util: mesh is not connected properly after
 recovery
From: Johannes Berg <johannes@sipsolutions.net>
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
Cc: Maital Hahn <maitalm@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 29 Jun 2016 09:20:30 +0200
In-Reply-To: <20160628111546.8932-1-yanivma@ti.com> (sfid-20160628_131320_130252_9109DD97)
References: <20160628111546.8932-1-yanivma@ti.com>
	 (sfid-20160628_131320_130252_9109DD97)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also - your subject lines should explain the *fix*, not the *bug*

johannes
