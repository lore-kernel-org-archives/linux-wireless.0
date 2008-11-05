Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48909 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYKEVgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 16:36:41 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Wed, 5 Nov 2008 19:36:43 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <970642.22610.qm@web23103.mail.ird.yahoo.com> <200811051342.05303.herton@mandriva.com.br> <4911D3CC.1050900@yahoo.co.uk>
In-Reply-To: <4911D3CC.1050900@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811051936.46361.herton@mandriva.com.br> (sfid-20081105_223645_819481_22801E24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 November 2008 15:11:40 Hin-Tak Leung wrote:
> Herton Ronaldo Krzesinski wrote:
> >> and applying the two patches on top, they applies cleanly and compile
> >> okay except for some warnings in a different module about missing
> >> symbols (<something>_sta) but the result dies very painfully with a
> >> kernel oops:
> >
> > Looks like something bad in combination of compat-wireless plus kernel
> > 2.6.27.4-73.fc10.x86_64, please try a plain wireless-testing tree with
> > the two patches.
>
> Hmm, I'll have to check, but I was a bit puzzled that compat-wireless
> didn't build the mac80211 module and the fc10 kernel didn't have one
> either. (and early kernels have a mac80211.ko). Has this been made
> obsolete, or did the fc10 kernel shipped it compiled-in and for some
> good/bad reason compat-wireless doesn't build modules that are compiled in?
> (obviously there is no point in building a module the older version of
> which is compiled in since it won't be used...)
>
> The status.retry_count vs status.rate[0].count change must be in
> mac80211.ko or some other more generic module?

Don't know about fc10 kernel, but the changes also include mac80211.ko

>
> Hin-Tak
> P.S. I know building a whole wireless-testing kernel is the way to go, but
> it takes *very long*...

--
[]'s
Herton
