Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0JGI4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 04:56:46 -0400
Subject: Re: [PATCH] iw: new command to set the wds peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1286393596-24547-1-git-send-email-bjordan@rajant.com>
References: <1286393596-24547-1-git-send-email-bjordan@rajant.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 10:56:39 +0200
Message-ID: <1286441799.3657.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 15:33 -0400, Bill Jordan wrote:

> +static int handle_interface_wds_peer(struct nl80211_state *state,
> +				 struct nl_cb *cb,
> +				 struct nl_msg *msg,
> +				 int argc, char **argv)

Please indent that up to just after the opening parenthesis.

> +	enum nl80211_iftype mac_addr[ETH_ALEN];

??

interface.c: In function ‘handle_interface_wds_peer’:
interface.c:397: warning: passing argument 1 of ‘mac_addr_a2n’ from incompatible pointer type
iw.h:119: note: expected ‘unsigned char *’ but argument is of type ‘enum nl80211_iftype *’


johannes

