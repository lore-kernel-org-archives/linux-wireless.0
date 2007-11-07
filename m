Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp002.mail.ukl.yahoo.com ([217.12.11.33]:47747 "HELO
	smtp002.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758311AbXKGO7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 09:59:51 -0500
From: Matteo Croce <rootkit85@yahoo.it>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: airo WPA
Date: Wed, 7 Nov 2007 15:59:47 +0100
Cc: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>,
	Matthieu Castet <castet.matthieu@free.fr>,
	Fabrice Bellet <fabrice@bellet.info>,
	"John W. Linville" <linville@tuxdriver.com>,
	PReDaCoN <alessandroferrari@gmail.com>,
	Benjamin Reed <breed@users.sourceforge.net>,
	Javier Achirica <achirica@users.sourceforge.net>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org
References: <200711070307.09832.rootkit85@yahoo.it> <200711071515.16623.rootkit85@yahoo.it> <1194446460.23444.6.camel@localhost.localdomain>
In-Reply-To: <1194446460.23444.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711071559.47916.rootkit85@yahoo.it> (sfid-20071107_145955_488043_51AAB8AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il Wednesday 07 November 2007 15:41:00 hai scritto:
> On Wed, 2007-11-07 at 15:15 +0100, Matteo Croce wrote:
> > New patch against current git
> 
> NAK at the moment; we've got too many patches for this floating around.
> I'm currently working out some issues with WPA with a pull from
> Matthieu's svn repo plus a set from Fabrice.  There's an issue with that
> set (that your patch also has) that causes WPA associations to fail
> because frames are driver-MIC-ed at the wrong times.  The patches also
> have some style issues that I'd like to clean up.
> 
> So here's what I'd like to do with the airo WPA patches.  They need to
> go through _one_ place.  Either I'll volunteer the time to handle them
> and people can feed them through me, or we need some other place where
> people can coordinate the work.  I'm happy to push this stuff through
> since it seems like most of the dual-mode issues have been solved.
> 
> The immediate bug is that the driver mis-MICs the first few EAPOL frames
> that come back during the 4-way handshake, failing the WPA association
> for PCMCIA cards at least.  I haven't tested with my mini-PCI part yet
> and won't until this can be fixed.  Once that appears to work, I'd like
> to run through a bunch of setups and make sure the driver behaves as
> expected for both WPA-capable and non-WPA-capable firmware versions, and
> with a number of different RADIUS setups and encryption modes including
> Dynamic WEP.
> 
> Dan
> 

So where to put the developing sources? Made the _one_ place
and me (i hope also others) could help.

Cheers,
Matteo
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 

