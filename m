Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3DVNdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:33:02 -0400
Message-ID: <1366637575.8637.8.camel@jlt4.sipsolutions.net> (sfid-20130422_153306_232757_1FBBEC4B)
Subject: Re: [PATCH] mac80211: indicate admission control in TX queue
 parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 22 Apr 2013 15:32:55 +0200
In-Reply-To: <1366119272-32666-1-git-send-email-johannes@sipsolutions.net> (sfid-20130416_153441_163732_656B5A95)
References: <1366119272-32666-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130416_153441_163732_656B5A95)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-16 at 15:34 +0200, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Some driver implementations need to know whether mandatory
> admission control is required by the AP for some ACs. Add
> a parameter to the TX queue parameters indicating this.
> 
> As there's currently no support for admission control in
> mac80211's AP implementation, it's only ever set for the
> client implementation.

Applied.

johannes

