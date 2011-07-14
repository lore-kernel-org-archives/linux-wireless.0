Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab1GNOEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 10:04:54 -0400
Date: Thu, 14 Jul 2011 16:05:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: reconfigure tx on device reconfiguration
Message-ID: <20110714140503.GA2327@redhat.com> (sfid-20110714_160457_519148_65D89F25)
References: <1310640029-22468-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310640029-22468-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 01:40:29PM +0300, Eliad Peller wrote:
> +	/* reconfigure tx conf */
> +	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
> +		drv_conf_tx(local, i, &local->tx_conf[i]);

Perhaps you should use hw->queues instead of IEEE80211_MAX_QUEUES ...

Stanislaw
