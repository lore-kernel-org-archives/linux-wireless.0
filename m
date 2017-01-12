Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46748 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdALPFz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 10:05:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: don't include mac80211.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170105123835.20995-1-johannes@sipsolutions.net>
References: <20170105123835.20995-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <20170112150542.7AE096120C@smtp.codeaurora.org> (sfid-20170112_160706_112953_95E2F4B0)
Date: Thu, 12 Jan 2017 15:05:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This driver doesn't use mac80211, so it shouldn't include mac80211.h,
> include only the necessary cfg80211.h instead.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Depends on:

3db5e3e707eb wireless: move IEEE80211_NUM_ACS to ieee80211.h

Currently in mac80211-next.

Patch set to Awaiting Upstream.

-- 
https://patchwork.kernel.org/patch/9498969/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
