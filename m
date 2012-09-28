Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2I1LG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 07:06:57 -0400
Message-ID: <1348830452.13298.28.camel@jlt4.sipsolutions.net> (sfid-20120928_130700_228315_EBD35FB4)
Subject: Re: [PATCH v2 5/5] mwifiex: use LOW_PRIORITY flag provided in scan
 request
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 28 Sep 2012 13:07:32 +0200
In-Reply-To: <1348772354-15936-6-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-6-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> The flag gives information about scan priority. This patch adds
> checks in the code to cancel/abort scan operation only for low
> priority scan requests.

I don't take mwifiex patches, so sending this in the same series isn't
all that useful.

Let's sort out the other stuff first, and then you can implement it in
the driver. :)

johannes

