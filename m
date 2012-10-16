Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2JPTsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:48:31 -0400
Message-ID: <1350416943.10177.18.camel@jlt4.sipsolutions.net> (sfid-20121016_214834_653149_040F6904)
Subject: Re: [PATCH] iw: add lowpri and flush scan operands
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 16 Oct 2012 21:49:03 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083B80DEE2@SC-VEXCH1.marvell.com>
References: <1350346947-21280-1-git-send-email-bzhao@marvell.com>
	 <1350412864.10177.9.camel@jlt4.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083B80DEE2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-16 at 12:43 -0700, Bing Zhao wrote:

> > > -TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive]", 0, 0,
> > > +TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive|lowpri|flush]",
> > 0, 0,
> > 
> > This seems a little wrong, you can't give lowpri/flush after giving
> > SSIDs, so it should probably be written as
> 
> I think we are adding lowpri/flush support as similar to 'passive' flag.

but "passive" is mutually exclusive with "ssid", while the flags aren't.

johannes

