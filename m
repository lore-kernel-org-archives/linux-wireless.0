Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbXJSGdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 02:33:25 -0400
Subject: Re: realtek 8185
From: Dan Williams <dcbw@redhat.com>
To: Wade Berrier <wberrier@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <bbbeeccd0710182154h5b42384cxb4bd49f5159504eb@mail.gmail.com>
References: <bbbeeccd0710160658p7f127bb9if2239287bee33d6c@mail.gmail.com>
	 <bbbeeccd0710162220u3b276506s68457b4220bec8ae@mail.gmail.com>
	 <bbbeeccd0710171552x37986f68m906a603e793c7996@mail.gmail.com>
	 <200710171938.48414.flamingice@sourmilk.net>
	 <bbbeeccd0710181013g6607423bobb31ca1e817f33c5@mail.gmail.com>
	 <20071018174108.GC8510@tuxdriver.com>
	 <bbbeeccd0710182154h5b42384cxb4bd49f5159504eb@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 02:32:48 -0400
Message-Id: <1192775568.14897.22.camel@localhost.localdomain> (sfid-20071019_073334_465066_7B397C9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-18 at 22:54 -0600, Wade Berrier wrote:
> Hi,
> 
> On 10/18/07, John W. Linville <linville@tuxdriver.com> wrote:
> > On Thu, Oct 18, 2007 at 11:13:00AM -0600, Wade Berrier wrote:
> > > On 10/17/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > > > On Wednesday 17 October 2007 18:52:28 Wade Berrier wrote:
> > > > > Another thing I'm noticing is that I can't connect to an 802.11b open
> > > > > network with a hidden essid.
> > > > >
> > > > For those, you should specify the channel, and bssid in one iwconfig command,
> > > > and then ssid in another command. Everything needs to be specified for hidden
> > > > networks. Never tried connecting to hidden networks with network manager so I
> > > > dunno if that's suppose to work.
> > >
> > > I've been able to connect to this hidden network via network manager.
> > > >From a users experience, I enter in the essid from the "Connect to
> > > other wireless network" dialog, and it connects.  I'm not sure how
> > > networkmanager makes the connection between the essid and the ap.
> >
> > If anything, I usually find that I can connect to the hidden networks
> > using iwconfig but _not_ with NetworkManager.  FWIW, mac80211 will
> > send probe requests for unknown SSIDs when trying to associate.
> 
> I can connect to this same network with an intel 2200.  The network
> comes up in the networkmanager list, but without and essid.
> 
> Is a hidden network the same thing as a network that doesn't broadcast
> the essid?

Yes.

> >
> > Unfortunately, I'm not really sure how this relates to the problem
> > you are having.  Perhaps probe responses are being lost somehow?
> 
> I'd assume it was driver related since I can with the intel 2200, but
> not with the realtek 8185.  I'm not sure; I guess I'd have to do some
> more digging.
> 
> Wade
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

