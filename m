Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35095 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDVH1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 03:27:23 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <874owhffe5.fsf@litku.valot.fi>
References: <1239837672.11795.46.camel@violet>
	 <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <874owhffe5.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 08:27:18 +0100
Message-Id: <1240385238.3404.0.camel@localhost.localdomain> (sfid-20090422_092727_321071_BC3D586A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> > so I have built the latest wireless-testing tree with a new patches sent
> > by Reinette fixing the DMA issue. So far I have no problems and I am
> > unable to re-produce it. However this is a different AP and I disabled
> > the power control feature for now.
> >
> > I also updated wpa_supplicant and iw to the latest code and assume that
> > no fix in there silently fixed it for me.
> >
> > So we are suspecting that this issue was because of me having 3GB of RAM
> > and running on a 64-bit kernel. Does this makes sense and could be the
> > problem why it kept failing until I unload the iwlagn driver?
> 
> I would say that don't make any assumptions until you manage to test
> with the original AP. APs can be broken so many ways.

I would agree with that in general, but I haven been using that AP for
over a year now successfully with the 4965 card in my X61. No problems
ever.

Regards

Marcel


