Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaDHIjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:39:43 -0400
Message-ID: <1396946371.5936.4.camel@jlt4.sipsolutions.net> (sfid-20140408_103950_941776_6D93336B)
Subject: Re: [PATCH] cfg80211: update comment about
 WIPHY_FLAG_CUSTOM_REGULATORY
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 10:39:31 +0200
In-Reply-To: <20140403070345.28730.75836.stgit@potku.adurom.net> (sfid-20140403_090457_092805_E553137B)
References: <20140403070345.28730.75836.stgit@potku.adurom.net>
	 (sfid-20140403_090457_092805_E553137B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-03 at 10:03 +0300, Kalle Valo wrote:
> Commit a2f73b6c5db3c ("cfg80211: move regulatory flags to their own variable")
> renamed WIPHY_FLAG_CUSTOM_REGULATORY to REGULATORY_CUSTOM_REG, but missed to
> update one comment.

Applied, thanks.

johannes

