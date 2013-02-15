Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3BOPnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 10:43:09 -0500
Message-ID: <1360942984.15040.19.camel@jlt4.sipsolutions.net> (sfid-20130215_164313_122351_C1163A62)
Subject: Re: [PATCH v2] mac80211: clean up mesh code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: marco@cozybit.com, thomas@cozybit.com
Date: Fri, 15 Feb 2013 16:43:04 +0100
In-Reply-To: <1360939611-937-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_154709_183850_AE901B1B)
References: <1360939611-937-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130215_154709_183850_AE901B1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 15:46 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's various code with strange indentation,
> questionable loop and locking constructs, etc.
> 
> The bigger change is moving the "sdata" argument
> to the first argument of all functions, like all
> other mac80211 functions that have one.

Applied.

johanens

