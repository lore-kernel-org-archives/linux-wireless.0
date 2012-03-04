Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2CDIMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:12:18 -0500
Subject: Re: [PATCH] compat-wireless: Handle name change from iwlagn to
 iwlwifi in 3.2
From: Johannes Berg <johannes@sipsolutions.net>
To: Don Fry <donald.h.fry@intel.com>
Cc: mcgrof@frijolero.org, linux-wireless@vger.kernel.org
In-Reply-To: <1325866731.9160.3.camel@dfry-linux1> (sfid-20120106_171934_327784_23D8F766)
References: <1325866731.9160.3.camel@dfry-linux1>
	 (sfid-20120106_171934_327784_23D8F766)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Mar 2012 09:12:12 +0100
Message-ID: <1330848732.4000.2.camel@jlt3.sipsolutions.net> (sfid-20120304_091221_769254_D5436C44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-01-06 at 08:18 -0800, Don Fry wrote:
> From: Don Fry <donald.h.fry@intel.com>
> 
> With linux-3.2 the iwlagn driver is renamed iwlwifi.  For some kernels
> (like 3.1.5) this causes the non-compat iwlagn.ko to try and run against
> the compat mac80211 resulting in a kernel oops.  This change prevents the
> non-compat iwlagn.ko from being loaded.

Hey Luis, I don't see this in your tree, did you just miss it?

johannes

