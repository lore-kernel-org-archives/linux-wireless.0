Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26029 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZH0P3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 11:29:24 -0400
Subject: Re: [PATCH] iwlagn: show_version() displays confusing/wrong
 firmware version
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87r5uxb8fi.fsf@nemi.mork.no>
References: <1251379989-20728-1-git-send-email-bjorn@mork.no>
	 <1251385041.3805.17.camel@rc-desk>  <87r5uxb8fi.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Aug 2009 08:29:12 -0700
Message-Id: <1251386952.3805.23.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjørn,

On Thu, 2009-08-27 at 08:09 -0700, Bjørn Mork wrote:
> reinette chatre <reinette.chatre@intel.com> writes:
> > Which kernel/repo is your patch based on?
> 
> Oh, sorry for not including that vital information.  I'm afraid it is
> against Linus' tree at 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> and not any of the wireless/networking trees.

Since 2.6.31 is considered a done deal and this is surely not the
required "earth shattering" fix (see [1]) I cannot push this as a fix
into Linus's repo at this time. This display problem will not exist in
2.6.32.

Reinette

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/38579

