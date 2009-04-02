Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30741 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZDBWa1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 18:30:27 -0400
Subject: Re: iwl3945: Don't queue rfkill_poll work when module is exiting
From: reinette chatre <reinette.chatre@intel.com>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: TJ <ubuntu@tjworld.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090325034121.GA4792@owl>
References: <1237909459.5365.16.camel@hephaestion>
	 <200903241851.11949.helmut.schaa@gmail.com>
	 <1237929739.5365.21.camel@hephaestion>  <20090325034121.GA4792@owl>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 15:36:06 -0700
Message-Id: <1238711766.21896.27.camel@rc-desk> (sfid-20090403_003029_774327_4988689A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Huaxu,

On Tue, 2009-03-24 at 20:41 -0700, Huaxu Wan wrote:
> Hi,
> 
> This issue is confirmed here too. But during compile, there is warning about
> cancel_work_sync(), cancel_delayed_work_sync() should be used instead.
> 
> And, without the modification in iwl3945_rfkill_poll() and 
> iwl3945_mac_stop(), just with one line cancel_delayed_work_sync(), this issue
> is also fixed in my testing.

TJ disappeared. We do need this fixed, would you like to submit your
patch instead?

Thanks

Reinette


