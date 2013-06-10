Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:33207 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab3FJR6f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 13:58:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	'Johannes Berg' <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Mon, 10 Jun 2013 10:52:43 -0700
Subject: RE: [PATCH v2 2/2] cfg80211/nl80211: Add packet coalesce support
Message-ID: <477F20668A386D41ADCC57781B1F70430EA268AEC0@SC-VEXCH1.marvell.com> (sfid-20130610_195839_044896_918A273E)
References: <1370273291.8227.24.camel@jlt4.sipsolutions.net>
 <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CB5@SC-VEXCH1.marvell.com>
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CB5@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > Can you please change this to "iw coalesce set" and make it set all the
> > rules in one?
> 
> "iw coalesce add" was used, because command for adding multiple rules at the same time will be a bit
> lengthy(user will need to enter multiple lists of packet patterns) and syntax check in iw will also
> need some efforts.
> 
> > Otherwise you're going to have very awkward races and need
> > to always clear etc. The code would also be easier, though obviously
> > you'd need to be able to specify multiple rules at the same time.
> 
> For "iw coalesce set" also user needs to always clear the settings using "iw coalesce disable". Also
> similar to "coalesce set", for "coalesce add" we clear the settings and free allocations while
> unloading the driver.
> 
> Please let us know if you prefer "coalesce set" over "coalesce add".

Could you please confirm your preference for "coalesce set" over "coalesce add"?

Thanks,
Bing

