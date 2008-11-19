Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23209 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYKSB5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 20:57:34 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Zhu Yi <yi.zhu@intel.com>
To: Thomas Witt <witt_th@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>,
	Jan =?ISO-8859-1?Q?Vc=28el=E1k?= <vcelak.jan@seznam.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <4922EF68.9020504@gmx.de>
References: <1226969241.4014.24.camel@johannes.berg>
	 (sfid-20081118_014839_339263_738F563C) <1227005769.4014.50.camel@johannes.berg>
	 <4922EF68.9020504@gmx.de>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 09:58:22 +0800
Message-Id: <1227059902.2548.173.camel@debian.sh.intel.com> (sfid-20081119_025738_677627_A07DD078)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-19 at 00:38 +0800, Thomas Witt wrote:
> Johannes Berg wrote:
> >> I'd like to ask anyone who is CC'ed (those are people I know ran into
> >> the bug) to try this patch.
> > 
> > And here's a version against v2.6.28-rc5 (build tested only)
> 
> 
> 
> That one fixes the Problem for me

Hey, you also said my patch fixed your problem in comment #42. ;-)

Johannes, FYI. From the last comment (#47) of bug
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703. The
problem is not totally solved.

Thanks,
-yi

