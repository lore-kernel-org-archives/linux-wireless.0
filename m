Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52859 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923AbbGQNSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:18:12 -0400
Message-ID: <1437139089.1933.14.camel@sipsolutions.net> (sfid-20150717_151814_960014_819748DD)
Subject: Re: [PATCH 02/10] cfg80211: use RTNL locked reg_can_beacon for
 IR-relaxation
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Fri, 17 Jul 2015 15:18:09 +0200
In-Reply-To: <1436359312-26533-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144212_150926_532CADAA)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-3-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144212_150926_532CADAA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-08 at 15:41 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> The RTNL is required to check for IR-relaxation conditions that allow
> more channels to beacon. Export an RTNL locked version of 
> reg_can_beacon
> and use it where possible in AP/STA interface type flows, where
> IR-relaxation may be applicable.
> 
Applied.

johannes
