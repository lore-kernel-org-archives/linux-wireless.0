Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33512 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1HCOCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 10:02:36 -0400
Date: Wed, 3 Aug 2011 09:48:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2] mwifiex: remove remaining wext usages
Message-ID: <20110803134815.GA30439@tuxdriver.com> (sfid-20110803_160240_191640_46DB6E04)
References: <1311305158-15534-1-git-send-email-bzhao@marvell.com>
 <477F20668A386D41ADCC57781B1F704307FFCC682E@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FFCC682E@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2011 at 02:37:30PM -0700, Bing Zhao wrote:
> Hi John,
> 
> > Subject: [PATCH v2] mwifiex: remove remaining wext usages
> > 
> > replace IW_MAX_AP & IW_CUSTOM_MAX with local definitions
> > and remove usage of struct iw_statistics.
> 
> Could you please take this patch if it looks OK?

There merge window is still open -- I'm not merging anything but fixes
right now.  I'll be happy to take this one when I start merging to
wireless-next again, after the release of 3.1-rc1.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
