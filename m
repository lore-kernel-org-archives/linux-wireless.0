Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40789 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYGNNSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 09:18:52 -0400
To: "Tomas Winkler" <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 1/2] mac80211: pass dtim_period to low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 14 Jul 2008 16:17:28 +0300
In-Reply-To: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com> (ext Tomas Winkler's message of "Mon\, 14 Jul 2008 15\:31\:23 +0300")
Message-ID: <87k5foob9z.fsf@nokia.com> (sfid-20080714_151856_036046_7DA32519)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomas.winkler@intel.com> writes:

> This patch adds the dtim_period in ieee80211_bss_conf, this allows the low
> level driver to know the dtim_period, and to plan power save accordingly.

Very good. This is a needed feature in my opinion.

-- 
Kalle Valo
