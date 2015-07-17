Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52943 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993AbbGQNnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:43:41 -0400
Message-ID: <1437140619.1933.21.camel@sipsolutions.net> (sfid-20150717_154345_215380_045B45B2)
Subject: Re: [PATCH 06/10] mac80211: remove
 ieee80211_aes_cmac_calculate_k1_k2()
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 15:43:39 +0200
In-Reply-To: <1436359312-26533-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144254_350866_ECD76AB0)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-7-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144254_350866_ECD76AB0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-08 at 15:41 +0300, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The iwlwifi driver was the only driver that used this, but as
> it turns out it never needed it, so we can remove it.
> 
I'm not applying this for now since it depends on the iwlwifi patch to
remove usage thereof :)

I think we said I'd apply that one also through my tree, but since it's
not urgent I'll sort it out later.

johannes
