Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19997 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1FHOe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 10:34:59 -0400
Subject: Re: bt coex active on iwlegacy?
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110608140524.GB2283@redhat.com>
References: <20110608140524.GB2283@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 07:31:24 -0700
Message-ID: <1307543484.5115.6.camel@wwguy-ubuntu> (sfid-20110608_163502_653117_CDB4DA50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 07:05 -0700, Stanislaw Gruszka wrote:
> Is bt_coex_active=true useful on iwlegacy? Or could be removed,
> or assigned to false by default? I'm asking regarding random, rare
> connections hangs and microcode errors that some people have on 4965.
> 
Back in 6000 time (2 years ago), we encounter problem on some of the
OEM's system has one of the pin raise high(I don't remember which pin)
all the time which cause our WiFi device believe there were BT traffic,
since BT traffic has higher priority then WiFi traffic, so the WiFi can
not establish connection. that is the main reason behind this module
parameter which used to disable bt coex. By default, the flag should set
to "true" unless the problem is being seen.

We continue to see this problem from time to time even it is not so
often. 

Thanks
Wey

 


