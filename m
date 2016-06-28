Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44898 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbcF1Ksm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 06:48:42 -0400
Message-ID: <1467110918.2493.9.camel@sipsolutions.net> (sfid-20160628_124846_198268_8BFF8AAF)
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, arnagara@codeaurora.org
Date: Tue, 28 Jun 2016 12:48:38 +0200
In-Reply-To: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-06-14 at 23:14 +0530, Ashok Raj Nagarajan wrote:
> This patch adds support to set transmit power setting type and
> transmit power level attributes to NL80211_CMD_SET_STATION in order
> to facilitate adjusting the transmit power level of a station
> associated to the AP.

Why would you ever need to do that manually? Please give more
explanation in the commit message.

We have minstrel-blues (which never made it into the code, but that's
just because the submitter went away) doing power adjustments, so you
need to explain why this should be necessary.

johannes
