Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59122 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753193AbdBGH4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 02:56:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: don't include mac80211.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170105123835.20995-1-johannes@sipsolutions.net>
References: <20170105123835.20995-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <20170207075649.056AC60A09@smtp.codeaurora.org> (sfid-20170207_085652_982818_CC3D2CC7)
Date: Tue,  7 Feb 2017 07:56:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This driver doesn't use mac80211, so it shouldn't include mac80211.h,
> include only the necessary cfg80211.h instead.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

50d55b6d3f1c mwifiex: don't include mac80211.h

-- 
https://patchwork.kernel.org/patch/9498969/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
