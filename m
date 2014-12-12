Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33269 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967631AbaLLMxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:53:48 -0500
Message-ID: <1418388824.2470.39.camel@sipsolutions.net> (sfid-20141212_135351_495566_6052F7EC)
Subject: Re: [PATCH iw v3 0/3] add WoWLAN net-detect trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 13:53:44 +0100
In-Reply-To: <1417208756-14839-1-git-send-email-luca@coelho.fi>
References: <1417208756-14839-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-28 at 23:05 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> A third spin.  This one includes parsing of some configuration
> information related to net-detect (patch 3/3).  I haven't send the
> nl80211 counterpart yet, but it's backwards compatible with the
> existing nl80211 code, so it doesn't matter if it's added in iw first.

Applied.

johannes

