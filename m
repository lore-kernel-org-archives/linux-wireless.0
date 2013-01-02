Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3ABM44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 07:56:56 -0500
Message-ID: <1357131438.9839.18.camel@jlt4.sipsolutions.net> (sfid-20130102_135659_274677_5BD48CC1)
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 13:57:18 +0100
In-Reply-To: <50E12058.8070106@qca.qualcomm.com>
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
	  <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>
	 <1356700150.9922.7.camel@jlt4.sipsolutions.net>
	 <50E12058.8070106@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-31 at 10:49 +0530, Vasanthakumar Thiagarajan wrote:

> > I think maybe if you want to continue supporting the white-&  blacklist
> > you should change it back to nested attributes, but treat the blacklist
> > there as an optimisation and ignore it for feature advertising.
> 
> Ok, so we dont need any mechanism to advertise supporting acl types at 
> all because any ACL supporting driver is supposed to support white
> list?.

I don't think that's guaranteed.

johannes

