Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:7878 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbXFMT7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 15:59:09 -0400
Received: by ug-out-1314.google.com with SMTP id j3so496617ugf
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2007 12:59:08 -0700 (PDT)
Message-ID: <46704C4D.5010803@googlemail.com>
Date: Wed, 13 Jun 2007 21:58:05 +0200
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	Samuel Ortiz <samuel@sortiz.org>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	James Morris <jmorris@namei.org>,
	Eric Paris <eparis@parisplace.org>,
	Ingo Molnar <mingo@elte.hu>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Paulo Pereira <pfmp.404@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v3
References: <46704B5D.5020106@googlemail.com>
In-Reply-To: <46704B5D.5020106@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here is a list of some known regressions in 2.6.22-rc4
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Networking

Subject    : no irda0 interface (2.6.21 was OK), smsc does not find chip
References : http://lkml.org/lkml/2007/6/3/16
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Samuel Ortiz <samuel@sortiz.org>
             Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch      : http://lkml.org/lkml/2007/6/7/237
Status     : patch was suggested



SELinux

Subject    : very high non-preempt latency in context_struct_compute_av()
References : http://lkml.org/lkml/2007/6/4/78
Submitter  : Ingo Molnar <mingo@elte.hu>
Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
             James Morris <jmorris@namei.org>
Patch      : http://lkml.org/lkml/2007/6/7/334
Status     : patch available



USB

Subject    : list_add corruption. prev->next should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
Submitter  : Paulo Pereira <pfmp.404@gmail.com>
Handled-By : Alan Stern <stern@rowland.harvard.edu>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
Status     : patch was suggested



Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
