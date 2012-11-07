Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2KGQ47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 11:56:59 -0500
Message-ID: <1352307454.9854.8.camel@jlt4.sipsolutions.net> (sfid-20121107_175719_968208_6EC72D26)
Subject: Re: [PATCH 1/2] cfg80211: store the ssid into wirless_dev in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Nov 2012 17:57:34 +0100
In-Reply-To: <1352289140-20515-1-git-send-email-ordex@autistici.org>
References: <1352289140-20515-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 12:52 +0100, Antonio Quartulli wrote:
> Store the configured ssid in wdev->ssid when starting an AP

Applied both.

johannes

