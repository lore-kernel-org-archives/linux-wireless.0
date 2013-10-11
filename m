Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:40070 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab3JKPm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 11:42:58 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so4432977wes.32
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 08:42:56 -0700 (PDT)
From: Detlev Casanova <detlev.casanova@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: NetworkManager not listing access points
Date: Fri, 11 Oct 2013 17:43:22 +0200
Message-ID: <3301062.MLBKDh0Ksv@naboo> (sfid-20131011_174301_577602_C059F93F)
In-Reply-To: <1381131658.13586.0.camel@jlt4.sipsolutions.net>
References: <31357461.i5mG9q5IfA@naboo> <2916718.7t7kLXuBQV@naboo> <1381131658.13586.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le lundi 7 octobre 2013 09:40:58 Johannes Berg a écrit :
> On Mon, 2013-10-07 at 08:48 +0200, Detlev Casanova wrote:
> > > > Yes and the problem is most likely to be in the driver because it
> > 
> > doesn't
> > 
> > > > occur before commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
> > 
> > ("cfg80211:
> > > > use DS or HT operation IEs to determine BSS channel")
> 
> [...]
> 
> > I looked into wpa_supplicant and after an upgrade from 0.7.3 to 2.0,
> > the problem seems to be fixed.
> 
> Huh, that's odd. Did 0.7.3 use wext driver?

Yes it did.
