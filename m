Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2J3Icv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:32:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TT7Fi-00077x-BM
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 09:32:50 +0100
Message-ID: <1351585960.10097.5.camel@jlt4.sipsolutions.net> (sfid-20121030_093300_395111_6D37AF88)
Subject: Re: [PATCH v2 0/4] multi-channel/interface TX power handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 30 Oct 2012 09:32:40 +0100
In-Reply-To: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_151853_919727_1AA2D71B)
References: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121026_151853_919727_1AA2D71B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 15:19 +0200, Johannes Berg wrote:
> Here's v2, keeping handling of phy TX power setting by
> telling the driver about it with a NULL wdev.

Applied all

johannes

