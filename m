Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JAHrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 03:47:10 -0400
Message-ID: <1349077663.10330.7.camel@jlt4.sipsolutions.net> (sfid-20121001_094714_484528_D0F0A931)
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Station mode SAE
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Oct 2012 09:47:43 +0200
In-Reply-To: <20120930162936.046757966@w1.fi>
References: <20120930162936.046757966@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 19:29 +0300, Jouni Malinen wrote:
> This series adds support to allow simultaneous authentication of equals
> (SAE) to be implemented in station mode with user space SME.

Applied, thanks. I made a change to the cfg80211/nl80211 patch to avoid
allowing SAE to be configured for connect/start-ap, please verify:
http://p.sipsolutions.net/0d315cdfcd0c447d.txt

johannes


