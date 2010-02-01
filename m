Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:40778 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab0BASTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 13:19:00 -0500
Received: by pxi12 with SMTP id 12so4679314pxi.33
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2010 10:18:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Feb 2010 10:18:39 -0800
Message-ID: <43e72e891002011018i671c5e05i9546f356cab43656@mail.gmail.com>
Subject: Re: 2.6.33-rc6: Reported regressions from 2.6.32
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 31, 2010 at 4:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Unresolved regressions
> ----------------------

Only one wireless regression:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15119
> Subject         : iwl_bg_scan_completed: WARN on scan complete
> Submitter       : Alex Zhavnerchik <alex.vizor@gmail.com>
> Date            : 2010-01-24 12:27 (8 days old)

And one rfkill lockdep complaint:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14999
> Subject         : possible circular locking dependency detected in rfkill at suspend
> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> Date            : 2010-01-06 21:52 (26 days old)

  Luis
