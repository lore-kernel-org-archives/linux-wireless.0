Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:35505 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754952AbXFGV1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 17:27:03 -0400
Message-ID: <4668DBE1.5090201@linux.intel.com>
Date: Thu, 07 Jun 2007 21:32:33 -0700
From: jketreno <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
References: <20070606082210.GA28649@mail.intel.com> <20070607223058.44122be4@griffin.suse.cz>
In-Reply-To: <20070607223058.44122be4@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Wed, 6 Jun 2007 16:22:10 +0800, Zhu Yi wrote:
>> --- a/include/linux/ieee80211.h
>> +++ b/include/linux/ieee80211.h
>> @@ -106,6 +106,52 @@ struct ieee80211_hdr {
...
>> +enum wifi_oui_stype_wmm {
>> +	WIFI_OUI_STYPE_WMM_INFO = 0,
>> +	WIFI_OUI_STYPE_WMM_PARAM = 1,
>> +	WIFI_OUI_STYPE_WMM_TSPEC = 2,
>> +};
> 
> Please don't invent new useless prefixes.

It doesn't really look like he invented a 'new useless' prefix.  It looks to me like he picked a prefix that correlates attribution of the data declaration to the entity that created it.  You may not like that he provided attribution, but that doesn't mean its useless.

If you'd rather use a different prefix, send a patch to fix it.

> Also, a registered trademark doesn't seem to be a good prefix.

Who holds 'WIFI' as a registered trademark?

James
