Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0CQAxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 20:53:46 -0400
Subject: Re: [PATCH] mac80211: Reschedule dynamic power save timer after
 wakeup
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
References: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 14:42:41 -0700
Message-ID: <1268775761.8918.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-16 at 11:31 -0400, Saravanan Dhanabal wrote:
> After last transmission, the device goes to sleep earlier
> than the configured dynamic power save timeout. If timeout
> is set to 400ms, device enters into sleep mode at around
> 330ms since from last TX.

So that means the scheduling to the workqueue takes you 70ms?

johannes

