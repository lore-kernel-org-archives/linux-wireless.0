Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932327AbdJ3Ksb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:48:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas: don't write wdev->ssid/_len
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171017193745.7604-1-johannes@sipsolutions.net>
References: <20171017193745.7604-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <20171030104830.DF30D60600@smtp.codeaurora.org> (sfid-20171030_114834_964441_305397FB)
Date: Mon, 30 Oct 2017 10:48:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> When joining an IBSS network, wdev->ssid/_len will already be
> set, so there's no need to write them. In any case, they are
> internal cfg80211 values, and have very little user-visible
> impact.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

39a9cd5a0e4e libertas: don't write wdev->ssid/_len

-- 
https://patchwork.kernel.org/patch/10012783/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
