Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55953 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaIKKS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:18:28 -0400
Message-ID: <1410430705.22863.3.camel@jlt4.sipsolutions.net> (sfid-20140911_121830_688421_E908CCC5)
Subject: Re: [PATCH v3 2/2] mac80211: implement cfg80211_ops to query mesh
 proxy path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 11 Sep 2014 12:18:25 +0200
In-Reply-To: <1409922404-8217-3-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140905_150657_745026_6A9E7166)
References: <1409922404-8217-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1409922404-8217-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20140905_150657_745026_6A9E7166)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-05 at 15:06 +0200, Henning Rogge wrote:
> Implement get_mpp and dump_mpp cfg80211_ops to export the content of the 802.11s mesh proxy path table to userspace.

line is also too long.

johannes

