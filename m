Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3FYIuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 04:50:07 -0400
Message-ID: <1372150202.8372.4.camel@jlt4.sipsolutions.net> (sfid-20130625_105017_737660_42C7D9A4)
Subject: Re: [PATCH v2] nl80211: fix mgmt tx status and testmode reporting
 for netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Jun 2013 10:50:02 +0200
In-Reply-To: <1372144637-1676-1-git-send-email-michal.kazior@tieto.com>
References: <1372074644-15280-1-git-send-email-michal.kazior@tieto.com>
	 <1372144637-1676-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-25 at 09:17 +0200, Michal Kazior wrote:
> These two events were sent to the default network
> namespace.
> 
> This caused AP mode in a non-default netns to not
> work correctly. Mgmt tx status was multicasted to
> a different (default) netns instead of the one the
> AP was in.

Applied, thanks.

johannes

