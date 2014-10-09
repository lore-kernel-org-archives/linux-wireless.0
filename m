Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJIJTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:19:40 -0400
Message-ID: <1412846378.1828.30.camel@jlt4.sipsolutions.net> (sfid-20141009_111942_849777_572177F0)
Subject: Re: [PATCH v4 0/2] cfg80211: Add export of mesh proxy path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 09 Oct 2014 11:19:38 +0200
In-Reply-To: <1410505130-7271-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140912_085920_262872_1C5CABC9)
References: <1410505130-7271-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20140912_085920_262872_1C5CABC9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-12 at 08:58 +0200, Henning Rogge wrote:
> The following patch series adds and implements two new cfg80211_ops that
> allow to query the content of the mac80211s mesh proxy path table via
> netlink.

Both applied.

johannes

