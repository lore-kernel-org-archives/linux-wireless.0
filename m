Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39770 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbBSTab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 14:30:31 -0500
Received: by mail-wg0-f49.google.com with SMTP id l18so9205548wgh.8
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 11:30:30 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 20 Feb 2015 01:00:10 +0530
Message-ID: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com> (sfid-20150219_203035_376982_5BB50F7C)
Subject: Connection issues with BW Tracking in mac80211
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

The BW tracking feature in mac80211 is causing connection problems and
operating mode/bw problems when switching b/w modes and bw's in AP.

For Eg. Initially if AP is operating in VHT-80MHz, and then we changed
in to HT-40MHz, mac80211 cannot handle it because the VHT capability
is mismatched b/w stored info (ifmgd->flags).

I have tried your DISABLE_BW_TRACK patch, that helps making the
connection but it doesn't update the chipset causing issues.

Ideally we should be able to handle all the config changes right?


-- 
Thanks,
Regards,
Chaitanya T K.
