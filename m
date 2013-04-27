Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3D0S3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 14:29:38 -0400
Message-ID: <1367085173.8445.0.camel@jlt4.sipsolutions.net> (sfid-20130427_202941_172558_BA796D0D)
Subject: Re: Intel Centrino Wireless-N 2230 (rev c4) bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Paolo Zaffino <p.zaffino@unicz.it>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Sat, 27 Apr 2013 19:52:53 +0200
In-Reply-To: <517BD02A.5060904@unicz.it> (sfid-20130427_151940_748350_F10D6AF1)
References: <517BD02A.5060904@unicz.it>
	 (sfid-20130427_151940_748350_F10D6AF1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-04-27 at 15:18 +0200, Paolo Zaffino wrote:


> [ 1756.822019] wlp3s0: deauthenticating from 74:ea:3a:cd:28:42 by local 
> choice (reason=3)

This is your problem, you're probably running two instances of
wpa_supplicant or something equally strange.

johannes

