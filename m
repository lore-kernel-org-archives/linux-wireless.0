Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54150 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaIBIDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 04:03:16 -0400
Message-ID: <1409644993.1808.4.camel@jlt4.sipsolutions.net> (sfid-20140902_100322_409164_2BA26C68)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Tue, 02 Sep 2014 10:03:13 +0200
In-Reply-To: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b> (sfid-20140901_132615_830692_B0FE7837)
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b>
	 (sfid-20140901_132615_830692_B0FE7837)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-01 at 13:26 +0200, Henning Rogge wrote:
> The following patch adds NL80211_CMD_GET_MPP as a new nl80211 command that
> allows to query the content of the 'mesh proxy path' table of mac80211s via
> 'get' or 'dump'  operation.

Is this really something that should be a generic nl80211 operation,
rather than say debugfs?

Could this be useful to other devices implementing the 11s, or is it
more of a mac80211 implementation detail?

johannes

