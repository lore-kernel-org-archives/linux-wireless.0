Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAGPfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:35:05 -0500
Message-ID: <1389108901.4645.13.camel@jlt4.sipsolutions.net> (sfid-20140107_163514_798907_55BF8783)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non
 modular
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:35:01 +0100
In-Reply-To: <1387486399-4053-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215336_839848_9765A659)
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
	 <1387486399-4053-3-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131219_215336_839848_9765A659)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
> This allows processing of the last regulatory request when
> we determine its still pending. This fixes the issue reported
> by Sander of when cfg80211 is built-in and no further regulatory
> domain processing can happen. This occurred because if the
> filesystem was not mounted upon kicking off the udev rule
> to run CRDA then the last request will always be left
> unprocessed.

It'd be good to comment on what this actually changes and what happens,
in addition to discussing the user-visible effect?

johannes

