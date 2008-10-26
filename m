Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:47010 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYJZIiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 04:38:06 -0400
Received: by ik-out-1112.google.com with SMTP id c29so18197ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 01:38:02 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Date: Sun, 26 Oct 2008 09:37:58 +0100
Cc: Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com> <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com> <1225008571.3478.14.camel@johannes.berg>
In-Reply-To: <1225008571.3478.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810260937.58724.IvDoorn@gmail.com> (sfid-20081026_093811_402312_4FC55E23)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 26 October 2008, Johannes Berg wrote:
> On Sat, 2008-10-25 at 18:20 -0700, Javier Cardona wrote:
> > Ivo,
> > 
> > On Sat, Oct 25, 2008 at 3:28 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > For rt2x00 this would turn into:
> > >        FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS
> > 
> > With the above configuration, will the rt2x00 device acknowledge 1)
> > unicast frames addressed to itself? 2) unicast frames addressed to
> > others? 3) none of the above?
> 
> It should always only be (1), mac80211 might set OTHER_BSS if it (well,
> the user) wants to see traffic on the same channel from other BSSes.

As far as I know, rt2x00 devices will only do (1).

Ivo
