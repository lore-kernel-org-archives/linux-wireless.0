Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33153 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYI2Ooi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 10:44:38 -0400
Date: Mon, 29 Sep 2008 10:44:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS
	mode
Message-ID: <20080929144402.GB3295@tuxdriver.com> (sfid-20080929_164442_845981_0752F401)
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 28, 2008 at 07:14:53PM +0300, Tomas Winkler wrote:

> @@ -963,6 +969,7 @@ enum ieee80211_category {
>  	WLAN_CATEGORY_SPECTRUM_MGMT = 0,
>  	WLAN_CATEGORY_QOS = 1,
>  	WLAN_CATEGORY_DLS = 2,
> +	WLAN_CATEGORY_HT = 7,
>  	WLAN_CATEGORY_BACK = 3,
>  	WLAN_CATEGORY_WMM = 17,
>  };

That would look nicer (to me) if it were in numerical order. :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
