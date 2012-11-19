Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:47:53 -0500
Message-ID: <1353336504.18299.16.camel@jlt4.sipsolutions.net> (sfid-20121119_154756_573211_0324F3E1)
Subject: Re: [PATCH] cfg80211: Add TDLS event to allow drivers to request
 operations
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 15:48:24 +0100
In-Reply-To: <20121116204957.GA32028@jouni.qca.qualcomm.com>
References: <20121116204957.GA32028@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:49 +0200, Jouni Malinen wrote:
> The NL80211_CMD_TDLS_OPER command was previously used only for userspace
> request for the kernel code to perform TDLS operations. However, there
> are also cases where the driver may need to request operations from
> userspace, e.g., when using security on the AP path. Add a new cfg80211
> function for generating a TDLS operation event for drivers to request a
> new link to be set up (NL80211_TDLS_SETUP) or an existing link to be
> torn down (NL80211_TDLS_TEARDOWN). Drivers can optionally use these
> events, e.g., based on noticing data traffic being sent to a peer
> station that is seen with good signal strength.

Applied.

johannes

