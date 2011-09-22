Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1IVHzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:55:48 -0400
Subject: Re: [RFC 1/5] nl80211: support sending TDLS commands/frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalyan Chakravarthy <chakkal@iit.edu>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <fac0da2d1631a.4e7a4ac6@iit.edu>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-2-git-send-email-arik@wizery.com>
	 <1316606076.3940.19.camel@jlt3.sipsolutions.net>
	 <fac0da2d1631a.4e7a4ac6@iit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 09:55:44 +0200
Message-ID: <1316678144.3899.1.camel@jlt3.sipsolutions.net> (sfid-20110922_095551_426623_8241871F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 20:36 -0400, Kalyan Chakravarthy wrote:
> I thought ATTR_FRAME would be more appropriate since it carries multiple IE's, such as RSN, FTIE etc.

ATTR_FRAME is typically used to carry a frame including header/fixed
portion, so ATTR_IE would be more appropriate if it doesn't include that
-- and the docs say multiple IEs can be there.

johannes

