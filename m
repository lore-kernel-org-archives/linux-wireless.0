Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:56396 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab3BITb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2013 14:31:59 -0500
Date: Sat, 9 Feb 2013 11:31:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/25] ipw2x00: simplify scan_event handling
Message-ID: <20130209193153.GG2875@htj.dyndns.org> (sfid-20130209_203221_743872_C8E70322)
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-5-git-send-email-tj@kernel.org>
 <CA++WF2MqUbwGv1Fek2BntZkvg=whw4gXHUDaditTBsDPdBMGxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA++WF2MqUbwGv1Fek2BntZkvg=whw4gXHUDaditTBsDPdBMGxw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2013 at 12:02:27AM +0300, Stanislav Yakovlev wrote:
> Hello, Tejun,
> 
> On 22 December 2012 04:56, Tejun Heo <tj@kernel.org> wrote:
> > * Drop unnesssary delayd_work_pending() tests.
> >
> > * Unify scan_event_{now|later} by using mod_delayed_work() w/ 0 delay
> >   for scan_event_now.
> >
> > * Make ipw2200 scan_event handling match ipw2100 - use
> >   mod_delayed_work() w/ 0 delay for immediate scanning.
> >
> > Only compile tested.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> > Cc: linux-wireless@vger.kernel.org
> > ---
> > Please let me know how this patch should be routed.  I can take it
> > through the workqueue tree if necessary.
> 
> Please, feel free to take it through your tree.
> 
> Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Queued to wq/for-3.9-cleanups.  Thanks!

-- 
tejun
