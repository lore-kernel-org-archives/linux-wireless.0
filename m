Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55950 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbaIKKSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:18:17 -0400
Message-ID: <1410430692.22863.2.camel@jlt4.sipsolutions.net> (sfid-20140911_121820_227074_6D9A3C0A)
Subject: Re: [PATCH v3 1/2] cfg80211: add ops to query mesh proxy path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 11 Sep 2014 12:18:12 +0200
In-Reply-To: <1409922404-8217-2-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140905_150655_262901_B377489F)
References: <1409922404-8217-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1409922404-8217-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20140905_150655_262901_B377489F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-05 at 15:06 +0200, Henning Rogge wrote:
> Add two new cfg80211 operations for querying the content of the the mac80211s proxy path table

Please use shorter line lengths, and formulate it in a generic way -
this shouldn't be mac80211 specific.

johannes

