Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38650 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754231Ab2EJSB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 14:01:29 -0400
Message-ID: <1336672887.22495.21.camel@joe2Laptop> (sfid-20120510_200133_385054_E8909B7E)
Subject: Re: [PATCH 1/4] iwlwifi: Add __printf argument checking to __iwl_dbg
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 10 May 2012 11:01:27 -0700
In-Reply-To: <1336671612.4334.25.camel@jlt3.sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	 <1336667905.22495.18.camel@joe2Laptop>
	 <1336668634.4334.23.camel@jlt3.sipsolutions.net>
	 <1336671240.22495.20.camel@joe2Laptop>
	 <1336671612.4334.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 19:40 +0200, Johannes Berg wrote:
> Checkpatch
> doesn't like it though if I put it in the same line as "static inline
> void" ;-)

checkpatch is both wise and stupid.


