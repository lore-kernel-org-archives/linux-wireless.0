Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:35332 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbYCFKhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 05:37:12 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3753266ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 02:37:11 -0800 (PST)
Message-ID: <95455e980803060237p40790e84w32004da91f5341e6@mail.gmail.com> (sfid-20080306_103719_202755_5DF73B85)
Date: Thu, 6 Mar 2008 21:37:10 +1100
From: hce <webmail.hce@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Patch for linux wireless extension
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204639101.7183.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <95455e980803031901x67360bffsca3794f1dfde586b@mail.gmail.com>
	 <1204626369.3917.96.camel@johannes.berg>
	 <1204639101.7183.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/5/08, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2008-03-04 at 11:26 +0100, Johannes Berg wrote:
>  > Jim,
>  >
>  > > I am running a wifi device on kernel 2.6.11 and wireless extension
>  > > version 17 for an ARM processor, it works fine with an open AP and
>  > > wpa_supplicant 0.5.8.
>  >
>  > That's ancient.
>  >
>  > > Now I would like to support WEP and WPA. I know
>  > > the best is to upgrade to latest kernel, but I am not in the position
>  > > to do it as various reasons.
>  >
>  > Upgrade anyway.
>  >
>  > > An alternative as people suggested is to
>  > > do a wireless extension patch which supports WEP and WPA on kernel
>  > > 2.6.11. Any advice if it is feasible and where can I find the wireless
>  > > extension patch for WEP and WPA on kernel 2.6.11 please?
>  >
>  > Hahaha. We'll you'll have to *make* that patch and invest a
>  > *significant* amount of time into that.
>
>
> Yeah; it's not just the defines and whatnot in wireless.h; you probably
>  also want to update wireless-tools too, then you have to update your
>  driver as well.  It's not hugely complex, but it's going to be a lot of
>  boring work :)
>
>
>  Dan

I've just upgrade wireless extension version 18 which supports WPA (Is
it for WEP as well?), with replaced two files of version 18 wireless.h
and wireless.c in the kernel 2.6.11. Please correct me if I missed
other source files in the kernel.

The wireless-tools we are using come from different sources, the
iwconfig was from busybox 1.3 and wpa_supplicant 0.5.8 was compiled to
our firmware. The initial test for WEP set up was not good, but I was
told, the wireless extension vresion 18 only supports WPA not WEP,
please advice.

Thank you.

Kind Regards,

Jim
