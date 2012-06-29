Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2F2MWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 08:22:36 -0400
Message-ID: <1340972552.4472.0.camel@jlt3.sipsolutions.net> (sfid-20120629_142240_247278_1DAF6A16)
Subject: Re: [PATCH v2] respect channels in iface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2012 14:22:32 +0200
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-29 at 12:46 +0200, Michal Kazior wrote:
> Hi,
> 
> The patchset introduces channel tracking per interface which is needed
> to start enforcing num_different_channels in interface combinations.
> Changes to monitor mode behaviour is also required for sane channel
> accounting (considering how mac80211 handles monitor interfaces).
> 
> This prepares cfg80211 for multi-channel operation.

All applied, thanks!

johannes

