Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab3CYNmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 09:42:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UK7fT-00050H-V0
	for linux-wireless@vger.kernel.org; Mon, 25 Mar 2013 14:42:32 +0100
Message-ID: <1364218948.17540.0.camel@jlt4.sipsolutions.net> (sfid-20130325_144240_391791_476A92FE)
Subject: Re: [PATCH 1/2] mac80211: ibss: disable beaconing before freeing
 beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 25 Mar 2013 14:42:28 +0100
In-Reply-To: <1363785131-909-1-git-send-email-johannes@sipsolutions.net> (sfid-20130320_141218_695715_2F47CFC8)
References: <1363785131-909-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130320_141218_695715_2F47CFC8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 14:12 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If we don't disable beaconing, the driver might attempt
> to continue, but would fail to request a beacon. That's
> strange, so disable beaconing first.

Applied both.

johannes

