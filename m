Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58019 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaGRH62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 03:58:28 -0400
Message-ID: <1405670302.19195.4.camel@jlt4.sipsolutions.net> (sfid-20140718_095831_300095_1B75A26E)
Subject: Re: [PATCH] cfg80211: fix mic_failure tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Fri, 18 Jul 2014 09:58:22 +0200
In-Reply-To: <1405598456-8512-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1405598456-8512-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-17 at 15:00 +0300, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> tsc can be NULL (mac80211 currently always passes NULL),
> resulting in NULL-dereference. check before copying it.

Applied.

johannes

