Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57413 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab0A2WPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 17:15:38 -0500
Date: Fri, 29 Jan 2010 17:04:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: shanyu.zhao@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1 v3] cfg80211: wext: fix cfg80211's SIOCSIWAP
	function
Message-ID: <20100129220401.GC28734@tuxdriver.com>
References: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2010 at 01:47:29PM -0800, shanyu.zhao@intel.com wrote:
> From: Shanyu Zhao <shanyu.zhao@intel.com>
> 
> The cfg80211's SIOCSIWAP function is broken, the reason is we cannot
> get the correct bss with previously set ssid. Need to clear it by
> setting ssid_len to 0 in cfg80211_mgd_wext_siwap() and fix other
> places accordingly.
> 
> Cc: stable@kernel.org
> 
> Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
> ---
> v2: Adding Cc to stable@kernel.org
> v3: set bssid to NULL in cfg80211_mgd_wext_siwessid, otherwise after
>     iwconfig wlanx ap <mac> the iwconfig wlanx essid won't work.

I already merged v2.  Please send the difference between v2 and v3
as a separate patch.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
