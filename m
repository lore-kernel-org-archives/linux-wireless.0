Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39978 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1BJXQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 18:16:59 -0500
Received: by ewy5 with SMTP id 5so1148404ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 15:16:58 -0800 (PST)
Message-ID: <4D547224.4020306@lwfinger.net>
Date: Thu, 10 Feb 2011 17:17:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Noel Milton Vega <nmvega@nyceyes.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Julian Calaby <julian.calaby@gmail.com>, ozan@pardus.org.tr,
	linux-wireless@vger.kernel.org
Subject: Re: UPDATE -- Need Linux driver (preferably 64 bit) for "Intel Corporation
 Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
References: <875258.44241.qm@web36104.mail.mud.yahoo.com> <20110210212508.GA2508@tuxdriver.com> <937938.34583.qm@web36102.mail.mud.yahoo.com>
In-Reply-To: <937938.34583.qm@web36102.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2011 05:08 PM, Noel Milton Vega wrote:
> 
>   > > In working with the kernel.org linux-wireless  developers, the conclusion
>   > > from one developer was that, though generally  speaking the
>   > > "Centrino Advanced-N 6230 AGN" card is supported by the  "iwlagn" kernel
>   > > module, it seems that the stock kernel module provided  in the
>   > > Fedora 14 kernel package (circa 2.6.35.10-74.fc14.x86_64), does  not
>   > > support the this card.
>   > > 
>   > > In other words, though code  in the main kernel.org git repository does
>   > > show support for the card  (via iwlagn kernel module), Fedora 14's
>   > > rendition/distribution of that  does not.
>   > 
>   > The point you seem to be missing is that your hardware is very  new,
>   > and the current Fedora 14 kernel is an "ancient" 6+ months  old.
>   >
> The point wasn't missed. In fact I highlighted the Fedora kernel
> version, and my card model to expressly make the point. Moreover,
> one of my suggested work-arounds was to try a newer kernel module
> (via compat-wireless) so as to bridge bridge that gap for this issue.
> 
>   > > Command  output during my debugging session with the developers is
>   > > shown below  for completeness, and in case the Fedora folks are
>   > >  monitoring.
>   > 
>   > I'm sorry, but your acquisition of bleeding-edge hardware  does not
>   > merit a change in the normal Fedora release  policy.
>   >
> Nothing in my email asked or expected them to. Still, the community
> in general should know what's going on. And, I did suggest two
> work-arounds in my email, neither of which asks anything of Fedora. 
> 
>   > P.S. I apologize if this seems rude -- that is  not my intent.
>   >
> Ah... This postscript repairs everything.

As an interested reader, he was not being rude. Usually, anyone that writes to
this list using the tone that you did, and continue to do, get blasted. You,
however, did not, but I predict that the gloves will soon come off!

Larry

