Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32856 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcBBPOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:14:17 -0500
Message-ID: <1454426048.2926.11.camel@sipsolutions.net> (sfid-20160202_161435_900785_21C21F98)
Subject: Re: [PATCH v2] mac80211: fix memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 02 Feb 2016 16:14:08 +0100
In-Reply-To: <1454399474-11350-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160202_085124_185619_6BDC7DF0)
References: <1454399474-11350-1-git-send-email-sudipm.mukherjee@gmail.com>
	 (sfid-20160202_085124_185619_6BDC7DF0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-02 at 13:21 +0530, Sudip Mukherjee wrote:
> From: Sudip Mukherjee <sudip@vectorindia.org>
> 
> On error we jumped to the error label and returned the error code but
> we missed releasing sinfo.
> 
Applied.

johannes
