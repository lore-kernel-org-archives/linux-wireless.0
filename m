Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab3CDPbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:31:06 -0500
Message-ID: <1362411061.21028.22.camel@jlt4.sipsolutions.net> (sfid-20130304_163112_583538_D2449BD9)
Subject: Re: [PATCH v3 1/6] cfg80211/mac80211: disconnect on suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 04 Mar 2013 16:31:01 +0100
In-Reply-To: <1362045330-2018-1-git-send-email-sgruszka@redhat.com>
References: <1362045330-2018-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 10:55 +0100, Stanislaw Gruszka wrote:
> If possible that after suspend, cfg80211 will receive request to
> disconnect what require action on interface that was removed during
> suspend.

Applied all.

johannes

