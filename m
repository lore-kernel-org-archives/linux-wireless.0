Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:62519 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdJ0Nxt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:53:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wil6210: remove SSID debugfs
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171017193355.7351-1-johannes@sipsolutions.net>
References: <20171017193355.7351-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <baf435810c4c4d79afdab84f7d708dbe@euamsexm01a.eu.qualcomm.com> (sfid-20171027_155541_138685_0D4DE6DB)
Date: Fri, 27 Oct 2017 15:53:42 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> This driver shouldn't be using wdev->ssid to start with, as
> it's more or less an internal field in cfg80211 used for
> various purposes. Reading it is possible through nl80211,
> even if that's not really what we should be doing there
> for anything but AP type interfaces.
> 
> It *really* shouldn't allow modifying it!
> 
> Remove the whole debugfs entry.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

698dbbf82bbf wil6210: remove SSID debugfs

-- 
https://patchwork.kernel.org/patch/10012771/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
