Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57196 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbaJWSma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 14:42:30 -0400
Message-ID: <1414089747.29820.0.camel@jlt4.sipsolutions.net> (sfid-20141023_204233_520932_F0565167)
Subject: Re: [PATCH] mac80211: add stations in order to the station list
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Thu, 23 Oct 2014 20:42:27 +0200
In-Reply-To: <1413970336-5728-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1413970336-5728-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 12:32 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> During reconfig the station list is traversed in order and station are
> added back to the driver. Make sure the stations are added to the driver
> in the same order they were added to mac80211.
> 
> This has a real side effect - some drivers (iwlwifi) require TDLS
> stations to be added only after the AP station for the same network.

Applied.

johannes

