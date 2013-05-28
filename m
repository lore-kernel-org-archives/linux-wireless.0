Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39252 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934660Ab3E1QWD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 12:22:03 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Johannes Berg' <johannes@sipsolutions.net>,
	Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Tue, 28 May 2013 09:21:44 -0700
Subject: RE: [PATCH v2 1/2] cfg80211/nl80211: rename packet pattern related
 structures and enums
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CA4@SC-VEXCH1.marvell.com> (sfid-20130528_182211_768636_658F460B)
In-Reply-To: <1369426217.8290.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for your comments.

> 
> > -enum nl80211_wowlan_packet_pattern_attr {
> 
> I think you missed a #define for this?

It's not used anywhere in iw or kernel code.

> 
> > +/* only for backward compatibility */
> > +#define __NL80211_WOWLAN_PKTPAT_INVALID __NL80211_INVALID,
> 
> that , at the end looks like a copy/paste error, but in fact shouldn't
> it be "__NL80211_PKTPAT_INVALID" anyway?

Thanks for pointing this out. We will correct it in updated version.

> 
> 
> >   * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
> >   * capability information given by the kernel to userspace.
> 
> Should this be updated?

It has been updated after adding coalesce support in 2/2 patch.

Thanks,
Amitkumar Karwar

> 
> johannes

