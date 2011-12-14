Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab1LNLgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:36:00 -0500
Subject: Re: [PATCH 0/5] station management rework
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1323862190.3380.6.camel@jlt3.sipsolutions.net> (sfid-20111214_123000_472902_38ADDCDA)
References: <20111214112026.409514167@sipsolutions.net>
	 (sfid-20111214_122400_723641_73C1DD48)  <1323862190.3380.6.camel@jlt3.sipsolutions.net>
	 (sfid-20111214_123000_472902_38ADDCDA)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 12:35:59 +0100
Message-ID: <1323862559.3380.8.camel@jlt3.sipsolutions.net> (sfid-20111214_123604_818364_D2B0ACAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-14 at 12:29 +0100, Johannes Berg wrote:
> Oops, please drop this for now -- the might_sleep() warning can trigger
> in IBSS mode, sorry!

Actually let's put this in without the might_sleep(), that makes it
easier to work on fixing IBSS.

johannes

