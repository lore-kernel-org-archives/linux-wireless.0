Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab3LSMjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 07:39:49 -0500
Message-ID: <1387456786.4298.11.camel@jlt4.sipsolutions.net> (sfid-20131219_133954_655695_DB39D125)
Subject: Re: [PATCH] nl80211: support vendor-specific events
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi
Date: Thu, 19 Dec 2013 13:39:46 +0100
In-Reply-To: <1387374996-4968-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_145647_374788_568DBF14)
References: <1387374996-4968-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131218_145647_374788_568DBF14)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-18 at 14:56 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In addition to vendor-specific commands, also support vendor-specific
> events. These must be registered with cfg80211 before they can be used.
> They're also advertised in nl80211 in the wiphy information so that
> userspace knows can be expected. The events themselves are sent on a
> new multicast group called "vendor".

Applied.

johannes

