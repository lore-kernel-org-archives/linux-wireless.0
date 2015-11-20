Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760569AbbKTPYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 10:24:40 -0500
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide unnecessary
 code
To: Johannes Berg <johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
From: Michal Marek <mmarek@suse.com>
Message-ID: <564F3B36.4040101@suse.com> (sfid-20151120_162444_176732_87AAF43A)
Date: Fri, 20 Nov 2015 16:24:38 +0100
MIME-Version: 1.0
In-Reply-To: <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-12 23:00, Johannes Berg wrote:
> +	count MAC80211_NUM_DRIVERS
> +	select MAC80211_DRIVER_NO_HWFLAGS

Hi Johannes,

The MAC80211_DRIVER_NO_HWFLAGS config does not seem to be used anywhere
in the logic.

Michal
