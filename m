Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2ILJi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 05:38:29 -0400
Message-ID: <1347442742.4293.4.camel@jlt4.sipsolutions.net> (sfid-20120912_113832_889285_F63190B7)
Subject: Re: [PATCH v1] Fix for regulatory in 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 12 Sep 2012 11:39:02 +0200
In-Reply-To: <14825905.k5l7QPk6IR@lx-vladimir>
References: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1347384193.4683.2.camel@jlt4.sipsolutions.net>
	 <14825905.k5l7QPk6IR@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-12 at 11:10 +0300, Vladimir Kondratiev wrote:

> > I don't really see a reason for that given that we don't have a driver
> > that uses 60g support anyway. Why should I pick it up anyway this late
> > in the cycle?

> Well, it is bug fix for 60g band that was merged. 

It was, but it never gets used.

> Also, I am readying
> driver for 60g card and will submit it shortly.

That won't be making it into 3.6 either though.

>  Having this bug fixed
> will help to 3-rd parties that want to experiment with 60g,
> and for 60g-related work in tools like wpa_supplicant and iw.

So I don't think this makes much sense? They'll probably use compat
anyway ;-)

I'll apply the patch to my -next branch after Luis reviews it.

johannes

