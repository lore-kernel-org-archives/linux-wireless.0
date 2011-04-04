Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1DDSQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 14:16:45 -0400
Subject: Re: [RFC] mac80211: prevent authentication on channel mismatch w/
 hw conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301937866-14701-1-git-send-email-rmanoharan@atheros.com>
References: <1301937866-14701-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 20:16:43 +0200
Message-ID: <1301941003.3795.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 22:54 +0530, Rajkumar Manoharan wrote:
> Do not proceed authentication if hw was already configured
> with one of the vif's channel which is differed with requesting
> channel. Not doing so is causing unneccesary dissociation.
> This issue was originaly found while testing concurrent mode
> with p2p vif.

This will break any kind of pre-authentication, no?

johannes

