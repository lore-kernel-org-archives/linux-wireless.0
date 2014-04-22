Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaDVPRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:17:51 -0400
Message-ID: <1398179856.4211.20.camel@jlt4.sipsolutions.net> (sfid-20140422_171848_272130_BE584C23)
Subject: Re: [PATCH 1/2] cfg80211: avoid freeing last_request while in flight
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, lkml20140418@newton.leun.net,
	arik@wizery.com, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 22 Apr 2014 17:17:36 +0200
In-Reply-To: <1398137975-14275-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20140422_053950_680580_BBAE1EB3)
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	 <1398137975-14275-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140422_053950_680580_BBAE1EB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 20:39 -0700, Luis R. Rodriguez wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Avoid freeing the last request while it is being processed. This can
> happen in some cases if reg_work is kicked for some reason while the
> currently pending request is in flight.

Applied.

johannes

