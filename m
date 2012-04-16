Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37671 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2DPRca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 13:32:30 -0400
Date: Mon, 16 Apr 2012 13:18:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/9] brcm80211: minor bug fixes for broadcom driver
Message-ID: <20120416171828.GB28941@tuxdriver.com> (sfid-20120416_193233_658958_F3E675B5)
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
 <20120413175717.GD2616@tuxdriver.com>
 <4F8BDD79.6030008@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8BDD79.6030008@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 10:51:05AM +0200, Arend van Spriel wrote:
> On 04/13/2012 07:57 PM, John W. Linville wrote:
> >On Wed, Apr 11, 2012 at 11:52:42AM +0200, Arend van Spriel wrote:
> >
> >In general, when mixing fixes and features/updates into a single
> >series then the fixes should come at the beginning of the series.
> >This helps to avoid dependencies on non-fix patches.
> >
> >I'll try to apply patch 9 to the wireless tree, and if that works I
> >won't complain about it... :-)
> >
> >John
> 
> Like mentioned on collaboration summit, we may need a bit more
> education on how to deal with stable fixes. I tagged the patch with
> cc to stable, but not sure if that is the correct way to do it. The
> stable rules are written in a generic way so I want know how the
> picture looks like when moving patches upstream via a maintainer
> tree.
> 
> So here is my understanding:
> 
> 1. submit patch without CC'ing stable against your wireless tree.
> 2. patch moves upstream to Dave's net tree.
> 3. patch moves further upstream to Linus' tree.
> 4. submit patch to stable with upstream commit id.
> 
> Is adding the CC to stable in step 1. a shortcut or is step 4. still
> necessary in that case?

Adding the CC in Step 1 should be sufficient.  Step 4 is required if
the CC is missed in Step 1.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
