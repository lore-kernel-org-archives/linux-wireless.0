Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZGaSwS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:52:18 -0400
Subject: Re: [PATCH 000/002] Fix frequent reconnects caused by new
 conection monitor
From: reinette chatre <reinette.chatre@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249056817.20593.1.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 11:52:18 -0700
Message-Id: <1249066338.30019.214.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 09:13 -0700, Maxim Levitsky wrote:
> Hi, here is the updated version of these two patches that fix the
> $SUBJECT issue.
> 
> I attach these (in case mailer mangles them), and reply with patches.
> 
> Tested both with low quality signal, and beacon loss.
> Lack of TX is found, every 30 seconds now, and quite reliable.
> Lack of beacons, triggers probe like it did every 2 seconds.

Thanks!

I've been running with this for two hours now with no disconnects. This
is where before the patches I would get disconnected after a few
minutes. I did get two "No probe response from AP xx:xx:xx:xx:xx:xx
after 500ms, try 1" messages in my log.

Reinette


