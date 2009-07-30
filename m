Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc4-s36.snt0.hotmail.com ([65.55.90.239]:13919 "EHLO
	snt0-omc4-s36.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbZG3WyL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 18:54:11 -0400
Message-ID: <SNT102-W61A452E2BB1C76DD78F435BD130@phx.gbl>
From: Jack Lau <jackelectronics@hotmail.com>
To: <proski@gnu.org>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
Date: Thu, 30 Jul 2009 22:48:01 +0000
In-Reply-To: <1248821338.5206.12.camel@mj>
References: <BAY0-DP2-2945C3011C834624418944BD170@phx.gbl>
	 <1248640816.32168.42.camel@mj>
 	 <BAY0-DP3-241EC0B1A0E15935251FCBBD150@phx.gbl>
 <1248821338.5206.12.camel@mj>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Pavel,
 
I have downloaded wireless-testing via git, compiled it and installed it which includes the below patch.
The git version was v2.6.31-rc4-29204-g6b3a8c9 (30/07/2009).
Unfortunately, I am still getting this very annoying crash.
 
Regards,
 
 
Jack

----------------------------------------
> Subject: RE: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
> From: proski@gnu.org
> To: jackelectronics@hotmail.com
> CC: linux-wireless@vger.kernel.org
> Date: Tue, 28 Jul 2009 18:48:58 -0400
>
> On Tue, 2009-07-28 at 21:21 +0000, Jack Lau wrote:
>
>>> I have enabled debugging in config.mk and installed it.
>
> I didn't suggest that. I think it's irrelevant. Only the setting
> in .config is relevant.
>
> If you are using compat-wireless, I suggest that you try the current
> kernel from wireless-testing. It was quite unstable a few days ago, but
> it should be cleaned up by now. Since you are using the AP mode, you'll
> need this patch, it's still not applied as of now:
>
> http://marc.info/?l=linux-wireless&m=124871936602667&w=2
>
> compat-wireless is great if everything is working, but if something is
> broken, the first suspicion is that compat-wireless doesn't backport
> something correctly.
>
>> The kernel already has debugging enabled as I have examined the
>> source from Ubuntu.
>
> Please be specific what you found and where. I don't have Ubuntu
> around, but others could correct you if you are looking in a wrong
> place.
>
>>> When I load the gdb command, I just get no debugging symbols found
>> and with the l command I just get no symbol file now.
>
> Please don't rephrase tell the error messages, especially if you don't
> understand them fully. I cannot see from your words why there are no
> debugging symbols.
>
> Also please don't top-post, as it makes it harder to quote the
> discussion in a reasonable way.
>
> --
> Regards,
> Pavel Roskin
_________________________________________________________________
Share your memories online with anyone you want.
http://clk.atdmt.com/UKM/go/134665338/direct/01/