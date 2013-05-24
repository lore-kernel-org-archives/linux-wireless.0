Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3EXV4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 17:56:48 -0400
Message-ID: <1369432601.13623.10.camel@johannes> (sfid-20130524_235651_412926_5771C528)
Subject: Re: [PATCH 1/3] {cfg,mac}80211: move mandatory rates calculation to
 cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Fri, 24 May 2013 23:56:41 +0200
In-Reply-To: <1368233453-10581-1-git-send-email-ashok@cozybit.com> (sfid-20130511_025106_872325_31B5141E)
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
	 (sfid-20130511_025106_872325_31B5141E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 17:50 -0700, Ashok Nagarajan wrote:
> Move mandatory rates calculation to cfg80211, shared with non mac80211 drivers.

Applied.

johannes

