Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3ABM7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 07:59:40 -0500
Message-ID: <1357131602.9839.20.camel@jlt4.sipsolutions.net> (sfid-20130102_135942_292350_F84750D1)
Subject: Re: [PATCH V6 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 14:00:02 +0100
In-Reply-To: <1357101213-9870-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1357101213-9870-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1357101213-9870-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 10:03 +0530, Vasanthakumar Thiagarajan wrote:

> V5:
> 	- Support for two mac lists, white and "optimization list"

> + * @NL80211_ACL_POLICY_ACCEPT: Allow the station to authenticate
> + * @NL80211_ACL_POLICY_OPTIMIZE: Optimize the acl, completely managed by driver

I think you're confused, maybe Jouni can help you out? :)

johannes

