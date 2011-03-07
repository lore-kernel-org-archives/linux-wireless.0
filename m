Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33089 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1CGPPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 10:15:47 -0500
Date: Mon, 7 Mar 2011 10:10:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 3/4] ieee80211: add IEEE80211_COUNTRY_STRING_LEN
 definition
Message-ID: <20110307151004.GB2664@tuxdriver.com>
References: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
 <1299302545-9672-3-git-send-email-bzhao@marvell.com>
 <1299483182.1816.1.camel@cumari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299483182.1816.1.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 07, 2011 at 09:33:02AM +0200, Luciano Coelho wrote:
> On Fri, 2011-03-04 at 21:22 -0800, Bing Zhao wrote:
> > and make use of it in wireless drivers
> > 
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > ---
> 
> For the wl12xx part:
> 
> Acked-by: Luciano Coelho <coelho@ti.com>
> 
> But I'd prefer if this patch was sent separately and not as part of a
> mwifiex series. (But this is John's call anyway ;)

Yes, probably better to send it separately.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
