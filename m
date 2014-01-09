Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaAIQFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 11:05:53 -0500
Message-ID: <1389283548.4348.4.camel@jlt4.sipsolutions.net> (sfid-20140109_170556_772668_786218A3)
Subject: Re: [PATCH] cfg80211: add sanity check for retry limit in
 wext-compat
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Date: Thu, 09 Jan 2014 17:05:48 +0100
In-Reply-To: <1389282374-12259-1-git-send-email-royujjal@gmail.com> (sfid-20140109_164631_677805_F45DB800)
References: <1389282374-12259-1-git-send-email-royujjal@gmail.com>
	 (sfid-20140109_164631_677805_F45DB800)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 21:16 +0530, Ujjal Roy wrote:
> Block setting the wrong values through iwconfig retry
> command. Add sanity checking before sending the retry
> limit to the driver.

Sure, applied. You'd probably be better off just turning off wext
though :)

johannes

