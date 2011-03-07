Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36785 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab1CGHdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 02:33:08 -0500
Received: by wwb29 with SMTP id 29so3879264wwb.22
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 23:33:05 -0800 (PST)
Subject: Re: [PATCH 3/4] ieee80211: add IEEE80211_COUNTRY_STRING_LEN
 definition
From: Luciano Coelho <coelho@ti.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1299302545-9672-3-git-send-email-bzhao@marvell.com>
References: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
	 <1299302545-9672-3-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 09:33:02 +0200
Message-ID: <1299483182.1816.1.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 21:22 -0800, Bing Zhao wrote:
> and make use of it in wireless drivers
> 
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---

For the wl12xx part:

Acked-by: Luciano Coelho <coelho@ti.com>

But I'd prefer if this patch was sent separately and not as part of a
mwifiex series. (But this is John's call anyway ;)

-- 
Cheers,
Luca.

