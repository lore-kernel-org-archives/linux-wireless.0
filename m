Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:35812 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab2ATGWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 01:22:44 -0500
Received: by mail-lpp01m010-f43.google.com with SMTP id o2so149491lag.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 22:22:42 -0800 (PST)
Subject: Re: [PATCH 2/2] mac80211: make CQM RSSI support per virtual
 interface
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120119083102.873553392@sipsolutions.net>
References: <20120119082956.486569312@sipsolutions.net>
	 <20120119083102.873553392@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jan 2012 08:22:39 +0200
Message-ID: <1327040559.4598.411.camel@cumari> (sfid-20120120_072246_479101_7DE8A0E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-19 at 09:29 +0100, Johannes Berg wrote:
> plain text document attachment (013-mac80211-cqm-rssi-per-vif.patch)
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Similar to the previous beacon filtering patch,
> make CQM RSSI support depend on the flags that
> the driver set for virtual interfaces.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---


For the wl1251 and wl12xx parts:

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

