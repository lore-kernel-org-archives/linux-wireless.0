Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab3BZUlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:41:16 -0500
Message-ID: <1361911267.8440.9.camel@jlt4.sipsolutions.net> (sfid-20130226_214119_639297_57C974C3)
Subject: Re: [PATCH 1/6] cfg80211: disconnect on suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 26 Feb 2013 21:41:07 +0100
In-Reply-To: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 12:50 +0100, Stanislaw Gruszka wrote:

> +void cfg80211_leave(struct cfg80211_registered_device *rdev,
> +		   struct wireless_dev *wdev);

missing a space here for indentation :)

> -		rtnl_unlock();
> +
>  	}

That added blank line is spurious.

I was going to fix these but have more concerns on the second patch.

johannes

