Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36988 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2KPTBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 14:01:33 -0500
Date: Fri, 16 Nov 2012 13:57:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] lib80211: hide Kconfig symbol
Message-ID: <20121116185721.GC29426@tuxdriver.com> (sfid-20121116_200136_627811_5D5D4251)
References: <1353020780-5459-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1353020780-5459-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2012 at 12:06:20AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to ask the user about lib80211
> since it will be selected by drivers requiring
> it, hide it from Kconfig.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

ACK -- I'll merge it...sorry that we still have to deal with this eyesore!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
