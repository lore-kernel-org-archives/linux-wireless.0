Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44674 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaEVO5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:57:08 -0400
Message-ID: <1400770624.4174.36.camel@jlt4.sipsolutions.net> (sfid-20140522_165712_132819_75E757EF)
Subject: Re: [PATCH v6 6/6] cfg80211: remove channel_switch combination check
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Thu, 22 May 2014 16:57:04 +0200
In-Reply-To: <1400767676-15994-7-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161513_340862_ECE2D308)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-7-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_161513_340862_ECE2D308)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
> Make the driver responsible for making sure it is
> capable of performing the switch. It might as well
> accept a request but then disconnect an interface
> if some requirements are not met.

Care to elaborate? I'd really like to avoid this case as much as
possible, so just mentioning here that it would be valid seems like a
bad idea.

johannes

