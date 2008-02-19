Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44239 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbYBSXsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 18:48:03 -0500
Date: Wed, 20 Feb 2008 00:48:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, "Zhu, Yi" <yi.zhu@intel.com>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ipw3945: not only it periodically dies, it also BUG()s
Message-ID: <20080219234822.GA23882@elf.ucw.cz> (sfid-20080219_234809_091203_B9E19952)
References: <20080205214441.GA1518@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982BB1@orsmsx416.amr.corp.intel.com> <20080206143218.GA16188@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com> <20080206210026.GA32641@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003ABD431@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D936D925018D154694D8A362EEB0892003ABD431@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > unfortunately the link here does not work. 
> 
> The instructions on how to report a bug have been updated to address the
> above issues. Thank you very much for helping us to make it better.

Thanks.

One more nit:

bugzilla-daemon@bughost.org seems like normal bugzilla, where you can
hit reply button, and control it using email... but that does not
actually work.

It would be nice to fix that. (Or at least make mail appear from
noreply@bughost.org, so that it is plain to see it does not work).

It seems that iwl3945 problem is somehow linked to
GROUP_SCHED... probably iwl can not handle latencies introduced by it?


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
