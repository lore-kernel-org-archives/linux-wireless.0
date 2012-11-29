Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:56478 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097Ab2K2OBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 09:01:40 -0500
Message-ID: <50B76AC0.3060507@posedge.com> (sfid-20121129_150143_562743_40AF7402)
Date: Thu, 29 Nov 2012 19:31:36 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: add debugfs file for current tx rate
References: <50B768A5.1040701@posedge.com> <1354197377.879.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354197377.879.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2012 07:26 PM, Johannes Berg wrote:
> On Thu, 2012-11-29 at 19:22 +0530, Saravana wrote:
>> Add a debugfs file showing the current tx rate.
>> The information available in the rc_stats file
>> doesn't evidently provides us the current tx rate.
>> This patch adds the support for the same.
> 
> Applied. But it doesn't actually require the *rx* rework, so I've left
> that out.
> 
*rx* rework is required for the last rx rate stat. 
After giving my rationale on the need for addition of 
last rx rate and mic failure count stat, i am waiting for 
your inputs regarding the same. 
> johannes
> 
> 

