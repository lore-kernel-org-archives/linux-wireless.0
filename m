Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1DMLyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 07:54:15 -0400
Message-ID: <4DA58ECB.9060602@redhat.com>
Date: Wed, 13 Apr 2011 19:53:47 +0800
From: Cong Wang <amwang@redhat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Patch] iwlwifi: remove obsoleted module alias and parameters
References: <1302083382-6715-1-git-send-email-amwang@redhat.com> <1302084582.3811.9.camel@jlt3.sipsolutions.net> <4D9C43A8.5060500@redhat.com> <20110406125728.GA2197@redhat.com> <20110412204941.GD24309@tuxdriver.com>
In-Reply-To: <20110412204941.GD24309@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

于 2011年04月13日 04:49, John W. Linville 写道:
> On Wed, Apr 06, 2011 at 02:57:29PM +0200, Stanislaw Gruszka wrote:
>> On Wed, Apr 06, 2011 at 06:42:48PM +0800, Cong Wang wrote:
>>> 于 2011年04月06日 18:09, Johannes Berg 写道:
>>>> On Wed, 2011-04-06 at 17:49 +0800, Amerigo Wang wrote:
>>>>> As scheduled in Documentation/feature-removal-schedule.txt,
>>>>> remove "*50", "disable_hw_scan" module parameters and MODULE_ALIAS("iwl4965").
>>>>
>>>> Mostly fine, but for iwlegacy Stanislaw we want to keep hw scan (and it
>>>> was actually made default now)
>>
>> Indeed, disable_hw_scan should be removed in iwlwifi but leaved in iwlegacy.
>>
>>> Ok, I will wait for Stanislaw's response and then send an updated patch.
>>
>> Have it now :-)
>
> Ping?
>

Huh?

The same patch from Wey-yi was merged as commit#7eaa6a5e964f1ab02d849bda36950c0d30be8ce2,
no?
