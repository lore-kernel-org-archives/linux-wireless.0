Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52670 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2FSHBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 03:01:46 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/2 v3] mac80211/cfg80211: add support for userspace to handle auth frames on adhoc ifaces
References: <4FDFC5B2.1010807@opentechinstitute.org>
Date: Tue, 19 Jun 2012 10:01:40 +0300
In-Reply-To: <4FDFC5B2.1010807@opentechinstitute.org> (Will Hawkins's message
	of "Mon, 18 Jun 2012 20:20:02 -0400")
Message-ID: <8762an6azv.fsf@purkki.adurom.net> (sfid-20120619_090158_520244_60892D40)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will Hawkins <hawkinsw@opentechinstitute.org> writes:

> Add cfg80211_mgmt_reg_match to cfg80211 to check for userspace
> application registrations for management frames rx'd from a specific
> interface. This function will be used by IBSS code to determine whether
> or not to send out "open" authentication frames.
>
> Update documentation for cfg80211_rx_mgmt to note that "query" frames
> are sent to matching userspace applications.
>
>
> Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>

What's the user visible benefit from this? Does it add new features or
something? You could document that in the commit log.

-- 
Kalle Valo
