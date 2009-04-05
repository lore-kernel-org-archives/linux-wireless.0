Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:39969 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbZDEKw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 06:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <20090403182724.GA7364@tuxdriver.com>
References: <20090403182724.GA7364@tuxdriver.com>
Date: Sun, 5 Apr 2009 13:52:25 +0300
Message-ID: <b25312890904050352n391f4707mfafca74aef8bca06@mail.gmail.com> (sfid-20090405_125234_691985_99B70D9E)
Subject: Re: Linux wireless mini-summit -- Berlin, June 2009
From: Rami Rosen <roszenrami@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I believe that 802.11n implementation and design in the Linux Wireless =
stack
can be of interest/good to include (also 802.11n Linux future direction=
s ).

Currently packet aggregation is implemented only with the ath9k and iwl=
wifi
mac80211 drivers (there are vendors who have non-native 802.11n
drivers as well).
Packet aggregation details (ampdu and amsdu RX) seems to me to be of in=
terest
(especially considering that there are chances of confirming the 802.11=
n spec at
the end of this year).

Regards,
Rami Rosen


On Fri, Apr 3, 2009 at 9:27 PM, John W. Linville <linville@tuxdriver.co=
m> wrote:
> Greetings,
>
> As you may know, we are planning on having a wireless summit meeting
> in Berlin, Germany this June. =A0This meeting is in cooperation with
> the Fedora FUDCon event, which will be accomodating us under the
> guise of a "hackfest". =A0This event also overlaps (and co-locates)
> with LinuxTag 2009. =A0Details are available here:
>
> =A0 =A0 =A0 =A0https://fedoraproject.org/wiki/FUDCon:Berlin_2009
>
> FUDCon's are typically self-organizing under the BarCamp model.
> However, I have secured a promise that we will be allocated space
> for 1-2 dozen people on at least Friday 26 June and Saturday 27 June
> for our wireless event. =A0I personally encourage everyone not only t=
o
> attend LinuxTag but also to participate in the rest of FUDCon!
>
> So, here I open the floor for discussion of agenda items for our
> wireless meeting/hackfest. =A0What do we think is important to discus=
s
> face-to-face this year? =A0What isn't getting done? =A0What is gettin=
g
> done wrong? =A0What do we need that we didn't realize last year?
>
> Also, please consider making some sort of prepared presentation.
> Especially welcome would be topics that are accessible to those
> outside of the core wireless developer group, such as current
> projects on enhancing IBSS support, extended power savings, or any
> other user-visible topic. =A0I'll be happy to take such proposals in
> private email or you can post them as part of this thread.
>
> Hopefully this gets the discussion started...please comment!
>
> John
>
> P.S. =A0We are also planning a meeting in Portland this September for
> those unable or unwilling to travel outside of North America for
> whatever reason -- stay tuned.
> --
> John W. Linville =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Someday the world wil=
l need a hero, and you
> linville@tuxdriver.com =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0might be al=
l we have. =A0Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
