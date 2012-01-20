Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54956 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab2ATGWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 01:22:22 -0500
Received: by lagj5 with SMTP id j5so226885lag.17
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 22:22:19 -0800 (PST)
Subject: Re: [PATCH 1/2] mac80211: make beacon filtering per virtual
 interface
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120119083102.737136632@sipsolutions.net>
References: <20120119082956.486569312@sipsolutions.net>
	 <20120119083102.737136632@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jan 2012 08:22:16 +0200
Message-ID: <1327040536.4598.410.camel@cumari> (sfid-20120120_072226_166252_072B4A3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-19 at 09:29 +0100, Johannes Berg wrote:
> plain text document attachment
> (012-mac80211-beacon-filter-per-vif.patch)
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Due to firmware limitations, we may not be able to
> support beacon filtering on all virtual interfaces.
> To allow this in mac80211, introduce per-interface
> driver capability flags that the driver sets when
> an interface is added.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

For the wl1251 and wl12xx parts:

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

