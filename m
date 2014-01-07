Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaAGPeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:34:13 -0500
Message-ID: <1389108849.4645.12.camel@jlt4.sipsolutions.net> (sfid-20140107_163415_902368_11E0B587)
Subject: Re: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:34:09 +0100
In-Reply-To: <1387486399-4053-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215331_944250_A52D0D00)
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
	 <1387486399-4053-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131219_215331_944250_A52D0D00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
> This addresses the RCU component of allowing us to reprocess
> the last regulatory request.

That commit message makes very little sense to me.

johannes

