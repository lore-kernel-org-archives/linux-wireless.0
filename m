Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:24652 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515AbXGYApd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 20:45:33 -0400
Received: by ug-out-1314.google.com with SMTP id j3so255509ugf
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2007 17:45:31 -0700 (PDT)
Message-ID: <e4c519350707241745l65315397o7452430a092ffdfb@mail.gmail.com>
Date: Wed, 25 Jul 2007 02:45:31 +0200
From: "Maurizio Monge" <maurizio.monge@gmail.com>
To: Stephen.Clark@seclark.us
Subject: Re: [ipw3945-devel] Request for help...
Cc: "Jeff Garzik" <jeff@garzik.org>,
	"James Ketrenos" <jketreno@linux.intel.com>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Axj <axjslack@bluebottle.com>
In-Reply-To: <46A69998.7020108@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252;
	format=flowed
References: <1185289332.46a61474a444c@mail.bluebottle.com>
	 <20070724161226.GA24344@tuxdriver.com> <46A64503.1080003@seclark.us>
	 <20070724203035.GG24344@tuxdriver.com> <46A66B63.6030006@garzik.org>
	 <46A6A447.2080903@linux.intel.com> <46A69359.4030201@garzik.org>
	 <46A69998.7020108@seclark.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I agree with Stephen, and i purchased a laptop with intel
graphics/wireless for exactly the same reason too.
Now i really hope that this thread instead of continuing as a flamewar
will positively help intel developer to have better interactions with
wireless-dev people, as it would be in the best interest for both.

My =80.02 (but note that they are =80 and not $ :) )

On 7/25/07, Stephen Clark <Stephen.Clark@seclark.us> wrote:
> Jeff Garzik wrote:
>
> >James Ketrenos wrote:
> >
> >
> >>Jeff Garzik wrote:
> >>
> >>
> >>
> >>>There is a reason why we say "release early, release often."  If
> >>>wireless developers don't hear from Intel on a regular basis,
> >>>
> >>>
> >>The "community" vs. "Intel" slant is really getting old.
> >>*WE* are part of the community.  *WE* have submitted patches.  *WE*=
 have
> >>done work to bring wireless forward.  *WE* are wireless developers.
> >>
> >>It isn't Intel's fault that certain people have historically made i=
t so
> >>difficult to get code to into wireless-dev's mac80211 (and eventual=
ly
> >>*maybe* upstream) that contributors have decided to focus on gettin=
g
> >>their code out to users through other means.
> >>
> >>A version of mac80211 being available out-of-tree with features not
> >>found in wireless-dev isn't the problem.  The problem is that peopl=
e
> >>have made it too difficult to innovate and develop in wireless-dev.
> >>
> >>
> >
> >Well, the facts according to my search are:
> >
> >* last iwlwifi submit was almost two months ago, in a form difficult=
 to
> >review and discuss on the mailing list, save for a bug fix.  And I n=
ote,
> >the submission went into wireless-dev rapidly.
> >
> >* last mac80211 patches were almost three months ago, save for two s=
mall
> >add-ioctl patches from Mohamed and Hong.
> >
> >* no one else seems to have the same trouble getting patches in
> >
> >Whereas other developers are actively posting patches, big and small=
, to
> >linux-wireless on a regular basis.  I just don't see much activity a=
t
> >all on {linux-kernel,linux-wireless,netdev} from Intel with regards =
to
> >the new wireless.
> >
> >Intel is the only wireless driver developer doing development
> >"elsewhere", rather than where the wireless hackers hang out.  Even
> >assuming a hypothetical worst case of 100% patch drops, you should b=
e
> >working and posting where other developers are also working and post=
ing.
> >  That is just a BASIC part of the open source kernel engineering pr=
ocess.
> >
> >Another key part of open source is "release early, release often" so
> >that people are aware of your work and needs, and can provide rapid
> >feedback.  That means posting most patches to linux-wireless as soon=
 as
> >they work on your basic quick-test setup.  Intel is definitely not
> >"releasing early and often" from the LKML perspective.
> >
> >Though in fairness, I am a bit disappointed that wireless-dev seems =
to
> >occasionally become a resting place for drivers, rather than just a =
pit
> >stop on the way to upstream.  In particular, stuff still has not bee=
n
> >moved out of drivers/net/wireless/mac80211 and into
> >drivers/net/wireless, which is a basic and easy step to get all code
> >ready for upstream.
> >
> >       Jeff
> >
> >
> >
> >
> I find it really sad that a hardware vendor that is willing to write =
and develope drivers for Linux for their hardware aren't helped more by=
 "the community" or is the "the community" only interested in hacking d=
rivers where the manufacturer give no or minimal support?
>
> I appreciate Intel's support for being open and purposely bought a la=
ptop that had an Intel graphics chipset and an Intel wireless card.
>
> My $.02
> Steve
> "They that give up essential liberty to obtain temporary safety,
> deserve neither liberty nor safety."  (Ben Franklin)
>
> "The course of history shows that as a government grows, liberty
> decreases."  (Thomas Jefferson)
>
>
>
>
> ---------------------------------------------------------------------=
----
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browse=
r.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>


--=20
Ciao
Maurizio
http://stregatto.wordpress.com

"Well we all shine on
Like the moon and the stars and the sun" (John Lennon)
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
