Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:22477 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759193AbXFGUr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:47:26 -0400
Message-ID: <4668D293.1010908@linux.intel.com>
Date: Thu, 07 Jun 2007 20:52:51 -0700
From: jketreno <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: "John W. Linville" <linville@tuxdriver.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: IEEE802.11e/WMM TS management and DLS support
References: <20070606082152.GA28639@mail.intel.com> <20070607224315.6dadffca@griffin.suse.cz>
In-Reply-To: <20070607224315.6dadffca@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Wed, 6 Jun 2007 16:21:54 +0800, Zhu Yi wrote:
>> This is a patch series for IEEE802.11e/WMM support against
>> linux-2.6.22-rc4.
>>
>> [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
>> [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
>> [PATCH 3/3] mac80211: debugfs support for TSM and DLS
> 
> John,
> 
> I see you already applied those patches. I haven't had a time to look
> at the second patch in this resent version yet, but even from the first
> and third one it's clear they still need a lot of work (for example,
> adding cfg80211 support instead of that debugfs interface isn't going
> to be a few lines long patch).
> 
> Please revert them.

Or better yet, let's develop them as a community by submitting patches to fix them.

James
