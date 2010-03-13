Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33762 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0CMMwj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 07:52:39 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NqQpa-0000Rx-36
	for linux-wireless@vger.kernel.org; Sat, 13 Mar 2010 13:52:38 +0100
Received: from cpc3-cmbg9-0-0-cust696.cmbg.cable.ntl.com ([81.103.22.185])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Mar 2010 13:52:38 +0100
Received: from jon.fairbairn by cpc3-cmbg9-0-0-cust696.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Mar 2010 13:52:38 +0100
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: [PATCH 0/2] ath5k: few AP fixes for 2.6.32
Date: Sat, 13 Mar 2010 12:52:26 +0000
Message-ID: <wfiq901j05.fsf@calligramme.charmers>
References: <1268349829-3195-1-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez"
<lrodriguez@atheros.com> writes:

> These patches were already merged into the latest 2.6.33.y,
> however they are not yet in the latest 2.6.32.y, they are
> reported to make ath5k AP support rock solid by a few people.
>
> For your conveinience I have also put these patches up here:
>
> http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath5k/2010-03/ath5k-ap-fixes-32/

Apologies for being ignorant of process, but which bundle of
compat-wireless do (/will?) these patches appear in, and which
version of 2.6.32 will they be in?

I'm running an ath5k AP on a 64-bit Fedora 12 system, and while
it was pretty reliable on 2.6.31, a recent update took the
version to 2.6.32 (currently running 3.6.32.9-67, and next
update is to 2.6.32.9-70 in case the Fedora version numbers make
sense to anyone reading this), and I'm getting the "no further
txbuf" issue, so I'd like to build a version of the module with
these patches, but ideally not a bleeding edge one.

Thanks,

  Jón

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


