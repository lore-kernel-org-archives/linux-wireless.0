Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40444 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbcEaJu1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 05:50:27 -0400
Message-ID: <1464688223.3076.5.camel@sipsolutions.net> (sfid-20160531_115059_944949_EF7C57D5)
Subject: Re: [PATCH 1/1] version.sh: update to get version with git correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Yongqin Liu <yongqin.liu@linaro.org>,
	linux-wireless@vger.kernel.org
Cc: filbranden@google.com
Date: Tue, 31 May 2016 11:50:23 +0200
In-Reply-To: <1462254528-15911-1-git-send-email-yongqin.liu@linaro.org> (sfid-20160503_075053_321143_A72BBFC5)
References: <1462254528-15911-1-git-send-email-yongqin.liu@linaro.org>
	 (sfid-20160503_075053_321143_A72BBFC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-03 at 13:48 +0800, Yongqin Liu wrote:
> update to get the version information from the
> git repository where this file is located instead of the
> the current directory where it is executed, otherwise if
> there is .git directory in the current directory, it will
> get the wrong version information.
> 
> And improved the version check since the tag information
> may not be mirrored like what AOSP does now.

Applied.

> Change-Id: I321113b74bf2a955c202f47dca68c1183ca55318
> 
I don't really need a change-id though :)

johannes
