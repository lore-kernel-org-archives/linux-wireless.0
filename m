Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3383 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2CMSdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 14:33:08 -0400
Message-ID: <4F5F92D8.2030101@broadcom.com> (sfid-20120313_193313_850204_8E5EA71B)
Date: Tue, 13 Mar 2012 11:32:56 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John Linville" <linville@tuxdriver.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] brmc80211: dont use jiffies for BSS TSF
References: <20120313125702.703540202@sipsolutions.net>
 <20120313125919.370791280@sipsolutions.net>
In-Reply-To: <20120313125919.370791280@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2012 05:57 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> The cfg80211_inform_bss() timestamp argument is
> intended to be the TSF, not any form of host
> timestamp.
>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>

Thanks Johannes.

Acked-by: Franky Lin <frankyl@broadcom.com>

