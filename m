Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3AKNcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 08:32:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TteiP-000556-FY
	for linux-wireless@vger.kernel.org; Fri, 11 Jan 2013 14:32:09 +0100
Message-ID: <1357911155.9767.3.camel@jlt4.sipsolutions.net> (sfid-20130111_143218_192784_2560496F)
Subject: Re: [PATCH] mac80211: fix HT40 connections
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 11 Jan 2013 14:32:35 +0100
In-Reply-To: <1357904065-11614-1-git-send-email-johannes@sipsolutions.net> (sfid-20130111_123414_306161_A306BB5E)
References: <1357904065-11614-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130111_123414_306161_A306BB5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 12:34 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My commit 4bf88530be971bf95a7830ca61b4120980bf4347
> ("mac80211: convert to channel definition struct")
> accidentally broke HT40 connections due to swapped
> channel flag checks -- fix that.

Applied.

johannes

