Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2FTISO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:18:14 -0400
Message-ID: <1340180293.4655.24.camel@jlt3.sipsolutions.net> (sfid-20120620_101819_585124_46517109)
Subject: Re: [RFCv2 03/13] cfg80211: add channel tracking for AP and mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:18:13 +0200
In-Reply-To: <1340172859-18146-4-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	 <1340172859-18146-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> We need to know which channel is used by a running
> AP and mesh for channel context accounting and
> finding matching/active interface combination.

I think there's the AP channel change function now that full-MAC drivers
can call -- need to update there?

johannes

