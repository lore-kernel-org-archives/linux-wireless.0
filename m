Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:45121 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYLISOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 13:14:22 -0500
Received: by ti-out-0910.google.com with SMTP id b6so38458tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 10:14:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18750.46333.603462.143624@localhost.localdomain> (sfid-20081209_191439_162356_D0730EBE)
Date: Tue, 9 Dec 2008 23:42:13 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jouni.malinen@atheros.com, lrodriguez@atheros.com,
	tomas.winkler@intel.com
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
In-Reply-To: <1228818258.22164.178.camel@johannes.berg>
References: <18750.13163.213759.181839@localhost.localdomain>
	<1228818258.22164.178.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Thanks, also for rebasing to the current tree. For all I care, we can
> apply this, but should maybe test on Intel hw?

Thanks for reviewing.
Yep, I think testing with Intel hw would be prudent. I'll do it tomorrow
(if I can find a 4965) and send out a patch.

Sujith
