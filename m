Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4743 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbYCYTIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 15:08:13 -0400
Date: Tue, 25 Mar 2008 14:32:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] net/mac80211/: Use time_* macros
Message-ID: <20080325183204.GA3646@tuxdriver.com> (sfid-20080325_190817_684948_96921899)
References: <1205746593-24820-1-git-send-email-caglar@pardus.org.tr> <1205746593-24820-2-git-send-email-caglar@pardus.org.tr> <1205746593-24820-3-git-send-email-caglar@pardus.org.tr> <1205746593-24820-4-git-send-email-caglar@pardus.org.tr> <1205746593-24820-5-git-send-email-caglar@pardus.org.tr> <1205746593-24820-6-git-send-email-caglar@pardus.org.tr> <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 11:36:29AM +0200, S.=C3=87a=C4=9Flar Onur wrote=
:
> The functions time_before, time_before_eq, time_after, and time_after=
_eq are more robust for comparing jiffies against other values.
>=20
> So following patch implements usage of the time_after() macro, define=
d at linux/jiffies.h, which deals with wrapping correctly

These two patches are already queues for 2.6.26.

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
