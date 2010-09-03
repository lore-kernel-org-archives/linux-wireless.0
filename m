Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0ICNMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 09:12:07 -0400
Subject: Re: [PATCH 0/13] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100903125528.GA2629@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283516518.4700.5.camel@jlt3.sipsolutions.net>
	 <20100903125528.GA2629@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 15:11:54 +0200
Message-ID: <1283519514.4700.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-03 at 14:55 +0200, Stanislaw Gruszka wrote:
> On Fri, Sep 03, 2010 at 02:21:58PM +0200, Johannes Berg wrote:
> > On Fri, 2010-09-03 at 13:57 +0200, Stanislaw Gruszka wrote:
> > 
> > [lots of patches]
> > 
> > Looks OK to me, apart from what I've pointed out,
> 
> All concerns are fixed by later patches.

Yeah, good point.

> > and I hope you've
> > tested it :-) I'm not an expert on the scanning code, to be honest.
> 
> I used below script on iwl3945. I plan to make some more testing, on
> iwlagn and with different scenarios. But patches improve things, it was
> easy to reproduce problem with script on iwl3945, with patches problem
> seems to gone.

Nice :-) AGN testing would be great.

johannes

