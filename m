Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2IKRWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 13:22:44 -0400
Message-ID: <1347384193.4683.2.camel@jlt4.sipsolutions.net> (sfid-20120911_192250_481589_64397D01)
Subject: Re: [PATCH v1] Fix for regulatory in 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 11 Sep 2012 19:23:13 +0200
In-Reply-To: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-11 at 14:52 +0300, Vladimir Kondratiev wrote:
> Another bit in 60g band support.
> 
> If possible, this is bug fix intended for 3.6

I don't really see a reason for that given that we don't have a driver
that uses 60g support anyway. Why should I pick it up anyway this late
in the cycle?

johannes

