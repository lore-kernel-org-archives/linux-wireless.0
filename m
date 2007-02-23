Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:33905 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbXBWVA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 16:00:27 -0500
Message-ID: <45DF5514.8000304@linux.intel.com>
Date: Fri, 23 Feb 2007 12:56:52 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211  optional
References: <45DF518B.5060809@linux.intel.com>
In-Reply-To: <45DF518B.5060809@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hold on applying.

> +cfg80211-$(CONFIG_NL80211) += nl80211.o

Should have been

cfg80211-$(CONFIG_CFG80211_NL80211) += nl80211.o

Am looking at Johannes' email re: WIRELESS_EXT being selected as well.  Will send a 
new version soon.

James
