Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59360 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936592AbXFGWtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 18:49:11 -0400
Date: Fri, 8 Jun 2007 00:49:09 +0200
From: Jiri Benc <jbenc@suse.cz>
To: jketreno <jketreno@linux.intel.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Message-ID: <20070608004909.7322f394@logostar.upir.cz>
In-Reply-To: <4668DBE1.5090201@linux.intel.com>
References: <20070606082210.GA28649@mail.intel.com>
	<20070607223058.44122be4@griffin.suse.cz>
	<4668DBE1.5090201@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 07 Jun 2007 21:32:33 -0700, jketreno wrote:
> It doesn't really look like he invented a 'new useless' prefix.  It looks
> to me like he picked a prefix that correlates attribution of the data
> declaration to the entity that created it.  You may not like that he
> provided attribution, but that doesn't mean its useless.

By "useless", I meant "if you use a WLAN_ prefix like in all other #defines
in that file, it will do the same job". Ok, I understand the argument about
attribution, but it shouldn't be in exchange of consistency and clarity.

> If you'd rather use a different prefix, send a patch to fix it.

I'd appreciate if you use a WLAN_ prefix in the next respin of the patch.

> Who holds 'WIFI' as a registered trademark?

Wi-Fi Alliance? Ok, it's "Wi-Fi", but you can use only capitals in macros
and you cannot use dash, so it looks really similar.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
