Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2GDIrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 04:47:06 -0400
From: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v1 0/2] High bitrate support
Date: Wed, 04 Jul 2012 11:46:59 +0300
Message-ID: <2060891.tTEPR1tQUd@lx-vladimir> (sfid-20120704_104711_126406_79F68A91)
In-Reply-To: <1341388464.4482.1.camel@jlt3.sipsolutions.net>
References: <1341386520-25244-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341388464.4482.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 04, 2012 09:54:24 AM Johannes Berg wrote:
> On Wed, 2012-07-04 at 10:21 +0300, Vladimir Kondratiev wrote:
> > Idea is to report (in nl80211) both old and new values,
> > or only new if it not fits into u16.
> > User space tools encouraged to migrate to the new bitrate.
> 
> Could you also send me a patch for iw to use it? :-)
> 
> johannes

Sending, together with some other iw stuff
