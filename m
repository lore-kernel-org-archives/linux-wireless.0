Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaEFOpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 10:45:24 -0400
Message-ID: <1399387510.4218.46.camel@jlt4.sipsolutions.net> (sfid-20140506_164526_971569_9EC2B4DD)
Subject: Re: [PATCH v4 4/5] mac80211: ignore cqm during csa
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 06 May 2014 16:45:10 +0200
In-Reply-To: <1397051137-26201-5-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155159_751316_E4329ABF)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-5-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140409_155159_751316_E4329ABF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
> It is not guaranteed that multi-vif channel
> switching is tightly synchronized. It makes sense
> to ignore cqm (missing beacons, et al) while csa
> is progressing and re-check it after it completes.

Makes sense, applied.

johannes

