Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58368 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbaJIOgW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 10:36:22 -0400
Message-ID: <1412865379.1828.52.camel@jlt4.sipsolutions.net> (sfid-20141009_163642_047236_9B4ADD91)
Subject: Re: [PATCH v2] Add mpp get/dump commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 09 Oct 2014 16:36:19 +0200
In-Reply-To: <1410505183-7325-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140912_085950_762977_39D61318)
References: <1410505183-7325-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20140912_085950_762977_39D61318)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-12 at 08:59 +0200, Henning Rogge wrote:
> Add the "mpp get" and "mpp dump" command to query to mac80211s mesh
> proxy path table through nl80211.

Applied.

>  nl80211.h | 11 +++++++++

Please don't send me nl80211.h updates though.

johannes

