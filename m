Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYLAX3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 18:29:34 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1228160229.10627.38.camel@johannes.berg>
References: <1226969241.4014.24.camel@johannes.berg>
	 <1228152631.10900.6.camel@rc-desk>
	 <1228160229.10627.38.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 15:30:29 -0800
Message-Id: <1228174229.10900.38.camel@rc-desk> (sfid-20081202_002938_474521_9B8D4868)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-01 at 11:37 -0800, Johannes Berg wrote:
> Reinette,
> 
> > Above you mention that this patch fixes bug #11596. Could you please
> > explain how this patch addresses that problem?
> 
> That looks like a mistake, I don't think it can fix that bug. I probably
> pasted the wrong URL, I had a whole bunch of iwlwifi bugs open
> everywhere around. I apologise for any problems caused by this, was this
> bug closed erroneously?

No problem was caused. The kernel.org bug was closed because one of the
reporters was unable to reproduce the issue after upgrading the kernel.
Unfortunately no particular patch was identified that specifically
addresses the problem. 

The bug in our system is still open because we still see the issue in
our test environment. We will keep digging.

Reinette

