Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0IBLhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 07:37:07 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100902110717.GC2372@redhat.com>
References: <20100831150021.GA10963@redhat.com>
	 <1283420177.3793.97.camel@jlt3.sipsolutions.net>
	 <20100902110717.GC2372@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 13:36:53 +0200
Message-ID: <1283427413.3793.103.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-02 at 13:07 +0200, Stanislaw Gruszka wrote:

> Ok, if you want to. I could to this as well, actually I should
> doing that way from the beginning.

I got started:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/011-iwl-remove-unused-conf.patch
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/012-iwl-unify-scan-checks.patch
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/013-iwl-fix-scan-queued-bug.patch
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/014-iwl-move-scan-completed.patch

but haven't really started addressing the actual problem. Want to take
it from here again? (oh and I also haven't tested these patches)

johannes

