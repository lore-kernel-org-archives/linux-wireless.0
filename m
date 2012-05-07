Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2144 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab2EGHzb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 03:55:31 -0400
Message-ID: <4FA77FE7.5030303@broadcom.com> (sfid-20120507_095535_836257_C6D452C8)
Date: Mon, 7 May 2012 09:55:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at net/mac80211/iface.c:162
References: <4FA709B3.4030404@lwfinger.net> (
 sfid-20120507_013135_141792_546F01AB)
 <1336372450.4325.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336372450.4325.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 08:34 AM, Johannes Berg wrote:
> On Sun, 2012-05-06 at 18:30 -0500, Larry Finger wrote:
>> Hi,
>>
>> I am getting the following warning from the latest wireless-testing system:
>>
>>   ------------[ cut here ]------------
>>   WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues+0x119/0x130 
>> [mac80211]()
> 
> 
>>       if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
>>
>> The warning is triggered for i, n_queues, and sdata->vif.hw_queue[i] all equal to 1.
> 
> Is this a driver with just a single queue by any chance? I never tested
> that and probably forgot to set those up correctly.
> 

The bug report Larry mentions is with iwlwifi driver:

pci, iwlwifi, NETWORK, Centrino Wireless-N 130 BGN

Gr. AvS

