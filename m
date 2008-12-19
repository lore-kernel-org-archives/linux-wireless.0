Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:43623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYLSVI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 16:08:29 -0500
Received: by fg-out-1718.google.com with SMTP id 19so465035fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 13:08:27 -0800 (PST)
Subject: Re: [ipw3945-devel] [PATCH 00/43] iwl3945 merges into iwlagn (Dec
 19)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 23:08:22 +0200
Message-Id: <1229720902.14021.10.camel@maxim-laptop> (sfid-20081219_220847_744300_59E6EAAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-12-19 at 10:37 +0800, Zhu Yi wrote:
> Hi John,
> 
> Here is the first batch for the iwl3945 -> iwlagn merge. This is for
> post .29 kernel.
> 
> Thanks,
> -yi
> 

This is very exiting.
There are some unpleasent bugs in iwl3945, like led code that stops
working in monitor mode, and monitor mode enabled forever, and speed
drops like I explained, so it would be nice to have single driver, as
most effor is put into 4965.

Also, want to ask same thing, how about to rename the driver to iwlwifi?

I assume that you will completely merge both drivers into single module,
right?

Currently only headers are merged.

Thanks, and best regards,
	Maxim Levitsky

