Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JGHuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 03:50:09 -0400
Message-ID: <1381132198.13586.1.camel@jlt4.sipsolutions.net> (sfid-20131007_095014_132067_3207FAF5)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680
 hardware
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	wcn36xx@qca.qualcomm.com
Date: Mon, 07 Oct 2013 09:49:58 +0200
In-Reply-To: <20131004234514.GA11128@garbanzo.do-not-panic.com> (sfid-20131005_013509_992900_728570EE)
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
	 <20131004234514.GA11128@garbanzo.do-not-panic.com>
	 (sfid-20131005_013509_992900_728570EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-04 at 16:45 -0700, Luis R. Rodriguez wrote:

> Nice! I test compiled with sparse enabled and got this:

Could also consider running smatch.

johannes

