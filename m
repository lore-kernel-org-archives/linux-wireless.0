Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBUJDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 04:03:04 -0500
Message-ID: <1392973379.4346.41.camel@jlt4.sipsolutions.net> (sfid-20140221_100319_964711_59B91896)
Subject: Re: [PATCH v5 4/5] cfg80211: Add an option to hint indoor operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Fri, 21 Feb 2014 10:02:59 +0100
In-Reply-To: <1392898909-15953-1-git-send-email-ilan.peer@intel.com> (sfid-20140220_131946_336789_F6B979EE)
References: <1392896671-4288-5-git-send-email-ilan.peer@intel.com>
	 <1392898909-15953-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20140220_131946_336789_F6B979EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 14:21 +0200, Ilan Peer wrote:

> +bool regulatory_indoor_allowed(void)
> +{
> +	return reg_is_indoor;
> +}
> +EXPORT_SYMBOL_GPL(regulatory_indoor_allowed);

I don't see any user of this (in particular none that would need it
exported)?

johannes

