Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1DDMUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 08:20:09 -0400
Subject: Re: [PATCH v6 10/10] nl80211: report mesh capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <1301690151-14979-11-git-send-email-thomas@cozybit.com>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
	 <1301690151-14979-11-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 14:20:07 +0200
Message-ID: <1301919607.3870.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 13:35 -0700, Thomas Pedersen wrote:
> NL80211_CMD_GET_WIPHY now returns a flag NL80211_SUPPORT_MESH_AUTH if
> the wiphy's mesh implementation supports routing of mesh auth frames to
> userspace.  This is useful for forward compatibility between old kernels
> and new userspace tools.

I think this should be part of patch 2, otherwise we have an
inconsistent state inbetween.

johannes

