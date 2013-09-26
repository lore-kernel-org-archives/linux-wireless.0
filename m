Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3IZR5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:57:43 -0400
Message-ID: <1380218260.4592.12.camel@jlt4.sipsolutions.net> (sfid-20130926_195747_710425_CBDC708E)
Subject: Re: [PATCH v3] mac80211: fix the setting of extended supported rate
 IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Colleen Twitty <colleen@cozybit.com>
Date: Thu, 26 Sep 2013 19:57:40 +0200
In-Reply-To: <1378622444-11247-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130908_084116_638954_3AF9F99D)
References: <1378622444-11247-1-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130908_084116_638954_3AF9F99D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-09-07 at 23:40 -0700, Chun-Yeow Yeoh wrote:
> The patch "mac80211: select and adjust bitrates according to
> channel mode" causes regression and breaks the extended supported rate
> IE setting. Since "i" is starting with 8, so this is not necessary
> to introduce "skip" here.

Applied.

johannes

