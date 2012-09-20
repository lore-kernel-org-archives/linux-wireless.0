Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2ITHzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 03:55:10 -0400
Message-ID: <1348127745.4161.13.camel@jlt4.sipsolutions.net> (sfid-20120920_095515_387047_87C958D9)
Subject: Re: [PATCH] mac80211 : Fix Ibss debug message Tx authentication
From: Johannes Berg <johannes@sipsolutions.net>
To: yes@test.org
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Date: Thu, 20 Sep 2012 09:55:45 +0200
In-Reply-To: <1348126101-30244-1-git-send-email-yes>
References: <yes> <1348126101-30244-1-git-send-email-yes>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 09:28 +0200, yes@test.org wrote:
> From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
> 
> In ibss debug message Tx authentication BSSID and DA address Were reversed

Thanks, please send a patch with signed-off-by though, see section 12 in
http://www.kernel.org/doc/Documentation/SubmittingPatches

johannes


