Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50635 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYIUNHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 09:07:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for Motorola 7010 variant of BCM4306
Date: Sun, 21 Sep 2008 15:07:05 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, bbullins@triad.rr.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net> <43e72e890809201359kb65f3d3qb618129ae6b528f4@mail.gmail.com> <1221944575.3023.10.camel@johannes.berg>
In-Reply-To: <1221944575.3023.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809211507.06119.mb@bu3sch.de> (sfid-20080921_150743_518910_96A9108B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 September 2008 23:02:55 Johannes Berg wrote:
> On Sat, 2008-09-20 at 13:59 -0700, Luis R. Rodriguez wrote:
> > On Sat, Sep 20, 2008 at 1:51 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Sat, 2008-09-20 at 17:44 +0200, Michael Buesch wrote:
> > >> On Friday 19 September 2008 21:47:38 Larry Finger wrote:
> > >> > An additional BCM4306 has been found with the Bluetooth coexistence
> > >> > SPROM coding error.
> > >
> > > Does anyone actually make laptops that use these bluetooth coexistence
> > > pins? All CSR bluetooth chips do it automatically I'm told, maybe we
> > > should just kill them completely.
> > 
> > Regardless of the wireless card? Or just for bcm?
> 
> Well just for b43(legacy), but out of curiosity, does any BT chip use
> these pins anyway? Well I guess _somebody_ has to buy BCMs BT chips,
> but ...

The wireless card for the powermac uses it.
I have one. (But I never tried whether it works correctly. I'm not sure
how to, anyway)

-- 
Greetings Michael.
