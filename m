Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57128 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJIJSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:18:44 -0400
Message-ID: <1412846322.1828.29.camel@jlt4.sipsolutions.net> (sfid-20141009_111847_742117_BC8BAA0C)
Subject: Re: [PATCH v4 2/2] mac80211: implement cfg80211_ops to query mesh
 proxy path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 09 Oct 2014 11:18:42 +0200
In-Reply-To: <CAGnRvurpXRa295P9eQsaR0HnE5o19HDZfwQRcjHk7wEfBYSbbQ@mail.gmail.com> (sfid-20141009_101047_525203_86B0F418)
References: <1410505130-7271-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1410505130-7271-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1412840290.1828.1.camel@jlt4.sipsolutions.net>
	 <CAGnRvurpXRa295P9eQsaR0HnE5o19HDZfwQRcjHk7wEfBYSbbQ@mail.gmail.com>
	 (sfid-20141009_101047_525203_86B0F418)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 10:10 +0200, Henning Rogge wrote:

> I think it should be reasonable safe. The variable is only increased
> (never decreased) and is used as a "information version number" for
> the dumps via netlink to the userspace. I think the current userspace
> tools ignore the variable completely.

Fair enough. I'll apply it. If an update is lost, it's likely that
userspace saw a previous value anyway.

johannes

