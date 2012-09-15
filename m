Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46681 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab2IOAzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 20:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XYjYrRSA8Xupu21GWoCd-jv63ic32Q3rP7YiVHajTWTg@mail.gmail.com>
References: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
 <CAB=NE6WBLusFkQP-a9mCxM2Hu-NyWvUiF8iALY6YvvbV81eKNg@mail.gmail.com> <CAB=NE6XYjYrRSA8Xupu21GWoCd-jv63ic32Q3rP7YiVHajTWTg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Sep 2012 17:55:09 -0700
Message-ID: <CAB=NE6UG647WMS7kW=xEFgU=PGMq7fdt7G0k_8sMqkkS9sZkcw@mail.gmail.com> (sfid-20120915_025535_349518_295ACD99)
Subject: Re: [PATCH 1/4] compat-drivers: update pending-stable patches.
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2012 at 5:51 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> I'm going to post that patch to uncrap it and to fix these releases.

OK I see these two defines are part of this patch:


commit 3e2ea543286dc2a4df46633a2ab6fda5f1a98cf3
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Jul 15 19:53:39 2012 +0200

    ath9k_hw: apply XLNA bias settings from EEPROM

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

So based on what I think you described you only want these two hunks
from that patch... to avoid regressions possibly caused by Felix'
other changes.

And this -- is why Felix's changes should have included those two
defines separately :)

  Luis
