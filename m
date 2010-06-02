Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37561 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0FBTqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 15:46:47 -0400
Received: by wyi11 with SMTP id 11so2176506wyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 12:46:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilHP9QwNPWVgJhVxYxQF8hzM9cd6-eVKOJc9qC3@mail.gmail.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<AANLkTikzEywcDi9zyJknMWkKymCVYnWQa2YXbbSDVx5o@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22343E33E611F@hasmsx502.ger.corp.intel.com>
	<AANLkTinG2zWHE8l-ZPBnyrFq5gs4nZX59zhF3AVh7h_4@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22343E33E6133@hasmsx502.ger.corp.intel.com>
	<AANLkTilHP9QwNPWVgJhVxYxQF8hzM9cd6-eVKOJc9qC3@mail.gmail.com>
Date: Wed, 2 Jun 2010 22:46:45 +0300
Message-ID: <AANLkTikxoZxZVp-1gLjXLy2XFrBz47SR6temPfBVDG-I@mail.gmail.com>
Subject: Re: [RFC] wireless-regdb: Add A band in IL
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> <emmanuel.grumbach@intel.com> wrote:
> >>On Wed, May 26, 2010 at 10:32 AM, Grumbach, Emmanuel
> >><emmanuel.grumbach@intel.com> wrote:
> >>>>>  country IL:
> >>>>>        (2402 - 2482 @ 40), (N/A, 20)
> >>>>> +       (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> >>>>> +       (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
> >>>>
> >>>>I believe the one standing issue here is you are enabling HT40 on 5
> >>>>GHz, how about enabling 2.4 GHz first, and then through a separate
> >>>>patch and time/review we review the HT40 stuff, unless you are in no
> >>>>rush to get 2.4 GHz enabled.
> >>>>
> >>>
> >>> I am not following... HT40 on 2.4 GHz is already enabled...
> >>> What should I enable in 2.4 GHz ?
> >>
> >>Sorry I meant 5 GHz.
> >
> > Actually 40GHz is less a problem in 5GHz than in 2.4GHz since in 2.4GHz
> > I need to have a "Coexistence mechanism", which is not required in 5GHz.
> > This Coexistence mechanism is apparently implemented by one OEM under the
> > name "Clear Channel Assessment (CCA)".
> >
> > In short, I don't think there is any special issue with 40MHz in 5GHz, but
> > I may miss something here... In any case, I have no problem with sending
> > a patch that allows 5GHz in 20MHz for the moment.
> > I can also have a look at the EEPROM in our NICs which is supposed to have
> > all the needed limitations. Details to follow tomorrow.
>
> OK thanks for the clarification Emmanuel, please give Michael some
> time to review.
>


How much time ? :-)
