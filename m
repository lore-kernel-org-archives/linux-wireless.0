Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2K3MiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:38:01 -0500
Message-ID: <1354279104.10035.27.camel@jlt4.sipsolutions.net> (sfid-20121130_133818_410796_2E4A2C8E)
Subject: Re: [PATCH] mac80211: allow userspace registration for ProbeReq in
 IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:38:24 +0100
In-Reply-To: <1354231092-10654-1-git-send-email-antonio@open-mesh.com>
References: <1354231092-10654-1-git-send-email-antonio@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 00:18 +0100, Antonio Quartulli wrote:
> This change allows userspace to register for ProbeReq on an
> IBSS interface.

I guess this is fine, you just have to handle them if you register for
them.

>  However ProbeRequests are not redirected from
> their normal rx path.

Well umm so the last sentence is just bogus, I'll delete it.

Applied.

johannes

