Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3395 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912AbYHAShO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 14:37:14 -0400
Date: Fri, 1 Aug 2008 14:11:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [GIT PATCH] RFC: next batch of rfkill changes
Message-ID: <20080801181135.GC14974@tuxdriver.com> (sfid-20080801_203735_374833_08672FE1)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 22, 2008 at 10:04:00PM -0300, Henrique de Moraes Holschuh wrote:
> 
> This is my next batch of rfkill changes.  They add features and address
> some shortcomings of rfkill-input, mostly.
> 
> Please comment.  One thing that is bothering me in the last patch is
> what happens during suspend/resume to pending delayed rfkill state
> changes.  Are pending scheduled jobs executed, cancelled, or frozen to
> fire up when the system resumes itself?
> 
> Henrique de Moraes Holschuh (6):
>       rfkill: detect bogus double-registering
>       rfkill: add default global states
>       rfkill: add master_switch_mode functionality
>       rfkill: add EPO lock to rfkill-input
>       rfkill: rename rfkill_mutex to rfkill_global_mutex
>       rfkill: rate-limit rfkill-input workqueue usage

FYI...because you included RFC in the subject I won't be merging
these until I hear otherwise from you.

John
-- 
John W. Linville
linville@tuxdriver.com
