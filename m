Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:47815 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbXJSEya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 00:54:30 -0400
Received: by py-out-1112.google.com with SMTP id u77so733783pyb
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2007 21:54:29 -0700 (PDT)
Message-ID: <bbbeeccd0710182154h5b42384cxb4bd49f5159504eb@mail.gmail.com> (sfid-20071019_055433_034923_A4CDB6B5)
Date: Thu, 18 Oct 2007 22:54:29 -0600
From: "Wade Berrier" <wberrier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: realtek 8185
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071018174108.GC8510@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <bbbeeccd0710160658p7f127bb9if2239287bee33d6c@mail.gmail.com>
	 <bbbeeccd0710162220u3b276506s68457b4220bec8ae@mail.gmail.com>
	 <bbbeeccd0710171552x37986f68m906a603e793c7996@mail.gmail.com>
	 <200710171938.48414.flamingice@sourmilk.net>
	 <bbbeeccd0710181013g6607423bobb31ca1e817f33c5@mail.gmail.com>
	 <20071018174108.GC8510@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 10/18/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Oct 18, 2007 at 11:13:00AM -0600, Wade Berrier wrote:
> > On 10/17/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > > On Wednesday 17 October 2007 18:52:28 Wade Berrier wrote:
> > > > Another thing I'm noticing is that I can't connect to an 802.11b open
> > > > network with a hidden essid.
> > > >
> > > For those, you should specify the channel, and bssid in one iwconfig command,
> > > and then ssid in another command. Everything needs to be specified for hidden
> > > networks. Never tried connecting to hidden networks with network manager so I
> > > dunno if that's suppose to work.
> >
> > I've been able to connect to this hidden network via network manager.
> > >From a users experience, I enter in the essid from the "Connect to
> > other wireless network" dialog, and it connects.  I'm not sure how
> > networkmanager makes the connection between the essid and the ap.
>
> If anything, I usually find that I can connect to the hidden networks
> using iwconfig but _not_ with NetworkManager.  FWIW, mac80211 will
> send probe requests for unknown SSIDs when trying to associate.

I can connect to this same network with an intel 2200.  The network
comes up in the networkmanager list, but without and essid.

Is a hidden network the same thing as a network that doesn't broadcast
the essid?

>
> Unfortunately, I'm not really sure how this relates to the problem
> you are having.  Perhaps probe responses are being lost somehow?

I'd assume it was driver related since I can with the intel 2200, but
not with the realtek 8185.  I'm not sure; I guess I'd have to do some
more digging.

Wade
