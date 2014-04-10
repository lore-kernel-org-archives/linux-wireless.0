Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaDJRNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 13:13:21 -0400
Message-ID: <1397149987.4757.23.camel@jlt4.sipsolutions.net> (sfid-20140410_191324_728824_CC56CE28)
Subject: Re: [RFCv2 2/6] mac80211: add new RC API to retrieve expected
 throughput
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Thu, 10 Apr 2014 19:13:07 +0200
In-Reply-To: <5346BCEB.1010700@open-mesh.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
		 <1396211704-4677-3-git-send-email-antonio@meshcoding.com>
	 <1396951430.5936.16.camel@jlt4.sipsolutions.net>
	 <5346BCEB.1010700@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 17:46 +0200, Antonio Quartulli wrote:

> > What about drivers with HW rate control?
> > 
> 
> True, they do not implement the rate_control_ops API.
> 
> Therefore, as discussed on IRC, I need to move this new API at the
> mac80211 level, so that each driver can implement it the way it prefer.

Well, not *move*, but rather have both. Or you can just say that the
drivers that may need this can worry about it ...

johannes

