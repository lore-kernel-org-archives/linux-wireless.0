Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965087AbaCSOZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:25:19 -0400
Message-ID: <1395239116.4142.24.camel@jlt4.sipsolutions.net> (sfid-20140319_152523_030154_F8B6E204)
Subject: Re: [PATCH 2/3] cfg80211: remove macro ASSERT_RDEV_LOCK(rdev)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:25:16 +0100
In-Reply-To: <c7fac3c56875d3466c480456b092ef4bac7a75c8.1395219362.git.gamerh2o@gmail.com> (sfid-20140319_100452_095529_65A8A2E1)
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
	 <c7fac3c56875d3466c480456b092ef4bac7a75c8.1395219362.git.gamerh2o@gmail.com>
	 (sfid-20140319_100452_095529_65A8A2E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-19 at 17:04 +0800, Zhao, Gang wrote:
> Macro ASSERT_RDEV_LOCK(rdev) is equal to ASSERT_RTNL(), so replace it
> with ASSERT_RTNL() and remove it.

Applied.

johannes

