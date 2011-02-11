Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp106.rog.mail.re2.yahoo.com ([68.142.225.204]:39722 "HELO
	smtp106.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750699Ab1BKDOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 22:14:33 -0500
Message-ID: <540970.60901.qm@smtp106.rog.mail.re2.yahoo.com>
From: Shawn Starr <shawn.starr@rogers.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period of time tanks causing contant drops
Date: Thu, 10 Feb 2011 22:07:48 -0500
In-Reply-To: <1297350984.20613.68.camel@wwguy-ubuntu>
References: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com> <20110209231526.cce3e7b7.akpm@linux-foundation.org> <1297350984.20613.68.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, February 10, 2011 07:16:24 AM wwguy wrote:
> On Wed, 2011-02-09 at 23:15 -0800, Andrew Morton wrote:
> > (cc linux-wireless)
> > 
> > On Sun, 06 Feb 2011 22:54 -0500 Shawn Starr <shawn.starr@rogers.com> 
wrote:
> > > Using a Intel Corporation PRO/Wireless 5100 AGN [Shiloh] card after
> > > rebooting and a period of of seveal hours signal begins to drop to
> > > low levels:
> > > 
> > > 
> > > wlan0     IEEE 802.11abgn  ESSID:"XXXXXXXX"
> > > 
> > >           Mode:Managed  Frequency:2.462 GHz  Access Point:
> > >           AA:BB:CC:DD:EE:FF Bit Rate=11 Mb/s  
> > >           Tx-Power=15 dBm
> > >           Retry  long limit:7   RTS thr:off   Fragment
> > >           thr:off
> > >           Power Management:off
> > >           Link Quality=12/70  Signal level=-98 dBm
> > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx
> > >           invalid frag:0
> > >           Tx excessive retries:0  Invalid misc:35   Missed
> > >           beacon:0
> > > 
> > > ...
> > > 
> > >           Link Quality=12/70  Signal level=-98 dBm
> > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx
> > >           invalid frag:0
> > >           Tx excessive retries:0  Invalid misc:40   Missed
> > >           beacon:0
> > > 
> > > I start seeing lots of Invalid misc errors and connection drops. If
> > > I reboot, then signal will be back to normal for a period of time
> > > again.
> > > 
> > > My official kernel is from Fedora rawhide
> > > (2.6.38-0.rc3.git4.1.fc15.x86_64)
> > > 
> > > Anyone else notice poor link/signal levels?
> > > 
> > > .37 showed no such issues.
> 
> did not see anything special from the log, is any environment or
> condition changed? what AP you are using?
> 
> Thanks
> Wey

I'm using an Linksys WRT54G with tomato firmware for a number of years. The AP 
is in my house and very close. I will keep an eye on this. This all seemed to 
have started after we had a power outage. The AP is fine however and I haven't 
noticed this drop a 2 after.

If there was any environment changes they appear to have 'settled' down.

I will be going to 2.6.38-0.rc4.git0.1.fc15 right now and will do another long 
hour test by keeping the laptop on for a number of hours on the weekend.

Thanks,
Shawn.


