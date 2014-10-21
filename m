Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45474 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369AbaJUTjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:39:15 -0400
Message-ID: <1413920347.1998.23.camel@jlt4.sipsolutions.net> (sfid-20141021_213917_999679_B3B089CD)
Subject: Re: [PATCH v2 5/6] mac80211-hwsim: support creating wiphy w/out
 creating wlanX.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Oct 2014 21:39:07 +0200
In-Reply-To: <1413845378-27837-5-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
	 <1413845378-27837-5-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:49 -0700, greearb@candelatech.com wrote:

> +				       u32 portid, char *hwname, bool no_vdev)

same comment regarding "vdev" throughout this patch.

Also, there shouldn't be a . at the end of the subject :-)

johannes


