Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0IBLqE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 07:46:04 -0400
Date: Thu, 2 Sep 2010 13:42:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100902114245.GD2372@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283420177.3793.97.camel@jlt3.sipsolutions.net>
 <20100902110717.GC2372@redhat.com>
 <1283427413.3793.103.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283427413.3793.103.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 02, 2010 at 01:36:53PM +0200, Johannes Berg wrote:
> On Thu, 2010-09-02 at 13:07 +0200, Stanislaw Gruszka wrote:
> 
> > Ok, if you want to. I could to this as well, actually I should
> > doing that way from the beginning.
> 
> I got started:
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/011-iwl-remove-unused-conf.patch
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/012-iwl-unify-scan-checks.patch
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/013-iwl-fix-scan-queued-bug.patch
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/014-iwl-move-scan-completed.patch
> 
> but haven't really started addressing the actual problem. Want to take
> it from here again? (oh and I also haven't tested these patches)

Yes, I will continue work of splitting patch, fix remaining issues, 
test and post. 

Stanislaw
