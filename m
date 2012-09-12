Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47781 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2ILIKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 04:10:25 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v1] Fix for regulatory in 60g
Date: Wed, 12 Sep 2012 11:10:20 +0300
Message-ID: <14825905.k5l7QPk6IR@lx-vladimir> (sfid-20120912_101035_341437_1AE5DDEC)
In-Reply-To: <1347384193.4683.2.camel@jlt4.sipsolutions.net>
References: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1347384193.4683.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, September 11, 2012 07:23:13 PM Johannes Berg wrote:
> On Tue, 2012-09-11 at 14:52 +0300, Vladimir Kondratiev wrote:
> > Another bit in 60g band support.
> > 
> > If possible, this is bug fix intended for 3.6
> 
> I don't really see a reason for that given that we don't have a driver
> that uses 60g support anyway. Why should I pick it up anyway this late
> in the cycle?
> 
> johannes

Well, it is bug fix for 60g band that was merged. Also, I am readying
driver for 60g card and will submit it shortly. Having this bug fixed
will help to 3-rd parties that want to experiment with 60g,
and for 60g-related work in tools like wpa_supplicant and iw.

If it is not looks reasonable, sure it can wait.

Thanks, Vladimir.
