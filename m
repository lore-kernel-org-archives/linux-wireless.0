Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4462 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbXJJOk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:40:29 -0400
Date: Wed, 10 Oct 2007 10:22:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: dragoran <drago01@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: mac80211/iwlwifi + hidden ssids
Message-ID: <20071010142200.GC5962@tuxdriver.com> (sfid-20071010_154039_186481_3823A0C0)
References: <470C9F28.1070803@gmail.com> <20071010130653.GB5962@tuxdriver.com> <f6ca9fed0710100647r208b0181xccecf1edd075c635@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0710100647r208b0181xccecf1edd075c635@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 03:47:27PM +0200, dragoran wrote:
> On 10/10/07, John W. Linville <linville@tuxdriver.com> wrote:
> > On Wed, Oct 10, 2007 at 11:45:12AM +0200, dragoran wrote:
> > > Hello,
> > > I am unable to connect to a dynamic wep network with hidden ssid using
> > > iwl3945 and the lastest fedora 7 kernel (which should have very recent

<snip>

> > Fedora 7 kernels are a little behind (1-2 weeks behind wireless-2.6)
> > ATM, so it might be best to handle this at bugzilla.kernel.org.
> 
> Ok, will file a bug after collecting more data (wpa_supplicant output).

Ooops, make that bugzilla.redhat.com please!

> > F7 _does_ have the kernel patch to probe for hidden SSIDs when
> > associating.  What I've found with that patch is that manually
> > invoking the wireless tools yields satisfactory results, but that NM
> > (which afaik relies on wpa_supplicant) still tends to have problems.

> I know I also followed the thread on the nm list but it seems that I
> cannot even get a connection with wpa_supplicant started by hand.

<snip>

> the wpa_supplicant.conf I tryed:
> -----------
> # this driver requires ap_scan=2 mode when using hidden SSIDs
> # request driver to take care of AP selection and roaming
> ap_scan=2

<snip>

> the exact same config works with the old stack.... should I try to
> change the ap_scan value to 1 ?

I think that would be worthwhile.

John
-- 
John W. Linville
linville@tuxdriver.com
