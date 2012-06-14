Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60348 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750732Ab2FNBNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 21:13:46 -0400
Message-ID: <1339636425.28729.11.camel@joe2Laptop> (sfid-20120614_031349_732385_D3D12221)
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 18:13:45 -0700
In-Reply-To: <4FD81E2C.1000507@qca.qualcomm.com>
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com>
	 <1339053852.6009.13.camel@joe2Laptop> <4FD05A27.80102@qca.qualcomm.com>
	 <1339055836.6009.20.camel@joe2Laptop> <4FD0688F.5020603@qca.qualcomm.com>
	 <1339098774.14838.4.camel@joe2Laptop> <4FD81E2C.1000507@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 10:29 +0530, Mohammed Shafi Shajakhan wrote:
> On Friday 08 June 2012 01:22 AM, Joe Perches wrote:
> > Please modify the patch based on wireless-next commit d63e9ae3b12
> sorry for the delayed reply. so you had already posted the change you 
> had suggested in (netdev@vger.kernel.org mailing list ?) and i have to 
> do any changes based on that patch right ? thank you!

Yes, pull wireless-next and start from there.

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=summary

cheers, Joe

