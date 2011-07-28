Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59395 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1G1RPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:15:02 -0400
Received: by qwk3 with SMTP id 3so1452007qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 10:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110728T174755-718@post.gmane.org>
References: <CAEzeFio8D9aKDFX+Wzo0yceWXy_5tDKpLDFzr9FmarTXCHUOQg@mail.gmail.com>
 <CAEzeFirXVu_pwDCb6t=ps4xskc4fFUy9gGECJgK1q7cYhLizVQ@mail.gmail.com>
 <CAEzeFip+PCV4Ccsi6L+RSvrM_86J2=Ps6193WyC0QzVfwe64LQ@mail.gmail.com>
 <CAEzeFiq2FXYKkfXjDtguryniaU7hQkJczLU98V9P3Uv5-D-P3g@mail.gmail.com>
 <CAB=NE6VT_Q5Apb_ZCfK9fSYGDtaUOwmVqeogN8HE6+SgGYek1A@mail.gmail.com>
 <CAEzeFiq5HXyazJfAx3mRV7TBy6CVEivJY63GkF8jnCczGsUK8Q@mail.gmail.com>
 <CAB=NE6WaRyX0yGs=6h6+2V+gUSPHoY19TTHuXBRAWqR9hw+qAw@mail.gmail.com>
 <loom.20110728T153639-332@post.gmane.org> <CAB=NE6WgWyc7a++e00Unf4WOqe7WV_D0rDxVfoXsFOXv7rkgOA@mail.gmail.com>
 <loom.20110728T172403-330@post.gmane.org> <CAB=NE6V4au2+fGeb==QhfGoVa747p773oUyYiSBT-SuW6PA4eA@mail.gmail.com>
 <loom.20110728T174755-718@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jul 2011 10:14:42 -0700
Message-ID: <CAB=NE6UmNmupUOHzeQHkTF7sX3BaoDQ8RN9wuBz2p3vak8eyXA@mail.gmail.com> (sfid-20110728_191507_006446_27D8D56D)
Subject: Re: Testing Auto Channel Selection with hostapd in ath5k and ath9k
To: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 8:48 AM, Swaminathan Vasanth
<swaminathanvasanth.r@gmail.com> wrote:
> Initially i was trying to get the source code without acs (available at
> git) and tried to patch it with the acs-all-in-one-v4.patch by placing the patch
> in in the patch directory of Openwrt/package/hostapd.(thought that the patch
> would be applied), but returned HUNK FAILED on patching ACS.
> So i pointed the local patched hostap files present in my home dir for building
> hostap with ACS. During the build process it throwed patch Failed errors for
> some other patches of hostapd in Openwrt like 300-scan_ssid.patch etc. So i
> compiled with the ACS integrated code alone and built it on the firmware. :(

I posted a v5 of the patches, that should be used, at this point
please consider waiting for the patches to be merged, otherwise please
leave out integration with OpenWrt out of this discussion, I'm frankly
not interested in the side issues with integration at this point, I'm
more interested in actual results. If its too difficult to integrate
please seek advice from the OpenWrt mailing list -- or just hold your
horses.

  Luis
