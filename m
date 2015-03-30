Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45657 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbbC3Ip7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:45:59 -0400
Message-ID: <1427705156.26117.12.camel@sipsolutions.net> (sfid-20150330_104602_176991_A085734D)
Subject: Re: [PATCH 4/5] wil6210: stop_ap to leave interface closed
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com
Date: Mon, 30 Mar 2015 10:45:56 +0200
In-Reply-To: <1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102927_412153_35AF5F44)
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20150330_102927_412153_35AF5F44)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 11:28 +0300, Vladimir Kondratiev wrote:
> cfg80211_ops.stop_ap supposed to have interface closed
> as post condition. Fulfill this requirement.

"closed" is rather misleading, since you most certainly should *not* do
dev_close() [and don't, but how should I know reading the commit log?]

johannes

