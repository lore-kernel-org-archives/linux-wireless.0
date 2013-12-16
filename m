Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3LPMsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:48:13 -0500
Message-ID: <1387198090.4665.25.camel@jlt4.sipsolutions.net> (sfid-20131216_134816_138982_65C0E6B0)
Subject: Re: [PATCH] mac80211: reschedule sched scan after HW restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Date: Mon, 16 Dec 2013 13:48:10 +0100
In-Reply-To: <1386532137-25099-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386532137-25099-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-08 at 21:48 +0200, Emmanuel Grumbach wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> Keep the sched scan req when starting sched scan, and reschedule
> it in case of HW restart during sched scan.
> The upper layer don't have to know about the restart.

Applied.

johannes

