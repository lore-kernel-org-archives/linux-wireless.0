Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3HAHb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 03:31:28 -0400
Message-ID: <1375342285.8608.1.camel@jlt4.sipsolutions.net> (sfid-20130801_093137_066587_2913BB63)
Subject: Re: [PATCH] mac80211: ibss - remove not authorized station earlier
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Thu, 01 Aug 2013 09:31:25 +0200
In-Reply-To: <1374866102-850-1-git-send-email-ordex@autistici.org>
References: <1374866102-850-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 21:15 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> A station which is not authorized has to be purged earlier
> to give it a chance to re-try to establish an IBSS/RSN
> session soon. Set the timeout to 10 seconds.
> 
> Some refactoring has also been done to allow the IBSS
> submodule to have its own expiring function.

Applied.

johannes

