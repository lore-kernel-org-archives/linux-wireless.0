Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32928 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaGXKnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:43:19 -0400
Message-ID: <1406198584.14675.8.camel@jlt4.sipsolutions.net> (sfid-20140724_124322_952880_A77288F3)
Subject: Re: [PATCH] mac80211: disable 40MHz support in case of 20MHz AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Thu, 24 Jul 2014 12:43:04 +0200
In-Reply-To: <1406190005-18611-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1406190005-18611-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 11:20 +0300, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> If the AP only advertises support for 20MHz (in the
> ht operation ie), disable 40MHz and VHT.

Applied.

johannes

