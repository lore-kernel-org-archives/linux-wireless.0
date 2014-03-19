Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965087AbaCSOZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:25:04 -0400
Message-ID: <1395239100.4142.23.camel@jlt4.sipsolutions.net> (sfid-20140319_152510_005594_E2F1E2F0)
Subject: Re: [PATCH 1/3] cfg80211: remove unnecessary check
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:25:00 +0100
In-Reply-To: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com> (sfid-20140319_100449_864887_42B63984)
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
	 (sfid-20140319_100449_864887_42B63984)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-19 at 17:04 +0800, Zhao, Gang wrote:
> RCU pointer bss->pub.beacon_ies is checked before in previous
> statement:
> 
> if (rcu_access_pointer(bss->pub.beacon_ies))
> 	continue;
> 
> There is no need to check it twice(and in the wrong way :) ).

Applied.

johannes

