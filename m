Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaAFO7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 09:59:12 -0500
Message-ID: <1389020348.5891.17.camel@jlt4.sipsolutions.net> (sfid-20140106_155914_447723_BF173E32)
Subject: Re: [PATCH] mac80211: add handler for memeory allocation failure
From: Johannes Berg <johannes@sipsolutions.net>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 06 Jan 2014 15:59:08 +0100
In-Reply-To: <46c874024953fa47667455051f304041827748e0.1388766243.git.gamerh2o@gmail.com> (sfid-20140103_174403_069069_2912560E)
References: <46c874024953fa47667455051f304041827748e0.1388766243.git.gamerh2o@gmail.com>
	 (sfid-20140103_174403_069069_2912560E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than bitch about this patch that has a useless subject and no
commit log, I've reimplemented the whole thing in a better way.

johannes

