Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbaDJICm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 04:02:42 -0400
Message-ID: <1397116944.4757.7.camel@jlt4.sipsolutions.net> (sfid-20140410_100256_873609_4B7F9E76)
Subject: Re: [PATCH 1/8] cfg80211: fix possible compile warning in
 wext-compat.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 10 Apr 2014 10:02:24 +0200
In-Reply-To: <8738hmfux8.fsf@gmail.com> (sfid-20140409_161838_074038_B9FB9FD2)
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	 <1397047610.4964.14.camel@jlt4.sipsolutions.net> <8738hmfux8.fsf@gmail.com>
	 (sfid-20140409_161838_074038_B9FB9FD2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 22:18 +0800, Zhao, Gang wrote:

> As I said in commit log, that parameter is not used in that function,
> and all the other functions in wext-compat.h use net_device as their
> parameters, I don't see any reason why this function should be specific.
> 
> Although changing the parameter type seems complicated the problem, I
> think it's the more reasonable way.

Fair enough. I'll take that patch.

johannes

