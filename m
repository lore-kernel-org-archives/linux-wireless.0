Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2HTLWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:22:05 -0400
Message-ID: <1345461721.4459.12.camel@jlt3.sipsolutions.net> (sfid-20120820_132209_005731_CE885411)
Subject: Re: [PATCH] mac80211: reconfigure channel contexts on
 ieee80211_reconfigure
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:22:01 +0200
In-Reply-To: <1344261169-19962-1-git-send-email-eliad@wizery.com> (sfid-20120806_155237_920097_A8562770)
References: <1344261169-19962-1-git-send-email-eliad@wizery.com>
	 (sfid-20120806_155237_920097_A8562770)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-06 at 16:52 +0300, Eliad Peller wrote:
> The channel contexts have to be re-added and re-assigned
> on device reconfiguration.

Thanks. I've applied it to the wip branch, but will probably just merge
it into the correct patch later.

johannes

