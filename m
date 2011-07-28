Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37641 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab1G1Ps4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 11:48:56 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QmSpS-0006kS-4k
	for linux-wireless@vger.kernel.org; Thu, 28 Jul 2011 17:48:54 +0200
Received: from tko-add-195.cs.hut.fi ([130.233.194.195])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 17:48:54 +0200
Received: from swaminathanvasanth.r by tko-add-195.cs.hut.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 17:48:54 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
Date: Thu, 28 Jul 2011 15:48:43 +0000 (UTC)
Message-ID: <loom.20110728T174755-718@post.gmane.org> (sfid-20110728_174904_456006_A479DA4A)
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com> <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com> <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com> <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com> <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com> <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com> <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com> <loom.20110728T153639-332@post.gmane.org> <CAB=NE6WgWyc7a++e00Unf4WOqe7WV_D0rDxVfoXsFOXv7rkgOA@mail.gmail.com> <loom.20110728T172403-330@post.gmane.org> <CAB=NE6V4au2+fGeb==QhfGoVa747p773oUyYiSBT-SuW6PA4eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initially i was trying to get the source code without acs (available at
git) and tried to patch it with the acs-all-in-one-v4.patch by placing the patch
in in the patch directory of Openwrt/package/hostapd.(thought that the patch
would be applied), but returned HUNK FAILED on patching ACS. 
So i pointed the local patched hostap files present in my home dir for building
hostap with ACS. During the build process it throwed patch Failed errors for
some other patches of hostapd in Openwrt like 300-scan_ssid.patch etc. So i
compiled with the ACS integrated code alone and built it on the firmware. :( 


