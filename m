Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3LPMj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:39:27 -0500
Message-ID: <1387197563.4665.17.camel@jlt4.sipsolutions.net> (sfid-20131216_133930_248809_81206C6E)
Subject: Re: [PATCH] mac80211: lock sdata in
 ieee80211_csa_connection_drop_work()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Date: Mon, 16 Dec 2013 13:39:23 +0100
In-Reply-To: <1386787186-6496-1-git-send-email-luciano.coelho@intel.com>
References: <1386787186-6496-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-11 at 20:39 +0200, Luciano Coelho wrote:
> We call ieee80211_ibss_disconnect(), which requires sdata to be
> locked, so lock the sdata during ieee80211_csa_connection_drop_work().

Applied.

johannes

