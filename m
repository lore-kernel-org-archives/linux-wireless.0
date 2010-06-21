Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab0FUWHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:07:25 -0400
Subject: Re: 2.6.35-rc3: Reported regressions from 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <AANLkTikVpTyNyYWf5xIO_3ok4OwbhxoiD40G3PAK8zp8@mail.gmail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
	 <AANLkTikVpTyNyYWf5xIO_3ok4OwbhxoiD40G3PAK8zp8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 15:07:24 -0700
Message-ID: <1277158044.25793.2177.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-21 at 11:49 -0700, Luis R. Rodriguez wrote:
> On Sun, Jun 20, 2010 at 3:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16235
> > Subject         : [REGRESSION] [IWL3945] Broadcast is broken?
> > Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date            : 2010-06-14 17:24 (7 days old)
> > Message-ID      : <201006141924.24061.maciej.rutecki@gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=127653628301300&w=2
> 
> As noted by Maxim, the fix is in some Intel tree, but not upstream yet
> (if so why ?)

The patch was merged into our tree a few days ago. It will be sent
upstream after our validation passes, which should be by the end of this
week. The repo in which it was merged is accessible to all if the patch
is needed sooner - a link is now included in that bug report.

Reinette


