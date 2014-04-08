Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbaDHNa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 09:30:26 -0400
Message-ID: <1396963807.11971.2.camel@jlt4.sipsolutions.net> (sfid-20140408_153031_935772_E864561C)
Subject: Re: [PATCH v3 00/13] cfg80211/mac80211: implement multi-vif chanctx
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 15:30:07 +0200
In-Reply-To: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134301_895786_6990540B)
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140331_134301_895786_6990540B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 12:39 +0200, Michal Kazior wrote:
> Hi,
> 
> This is part of my multi-vif csa work. These
> patches have been included in my recent big RFC.
> I'm trying to split it up a bit.
> 
> The patchset incrementally improves chanctx
> reservations in order to support multi-vif
> reservations and in-place multi-vif reservations
> (typically for single-channel hardware, but
> multi-channel benefits from this too).
> 
> Some of the patches (the refcounting) were also
> posted a while ago as a separate small RFC.
> 
> This is rebased on mac80211-next/master and my
> CSA fixes/cleanups now.

I guess this looks fine ... Is Luca planning to pick it up first?

johannes

