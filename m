Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3439 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563AbXJRSJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 14:09:01 -0400
Date: Thu, 18 Oct 2007 13:41:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wade Berrier <wberrier@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: realtek 8185
Message-ID: <20071018174108.GC8510@tuxdriver.com> (sfid-20071018_190906_915820_DD689A76)
References: <bbbeeccd0710160658p7f127bb9if2239287bee33d6c@mail.gmail.com> <bbbeeccd0710162220u3b276506s68457b4220bec8ae@mail.gmail.com> <bbbeeccd0710171552x37986f68m906a603e793c7996@mail.gmail.com> <200710171938.48414.flamingice@sourmilk.net> <bbbeeccd0710181013g6607423bobb31ca1e817f33c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bbbeeccd0710181013g6607423bobb31ca1e817f33c5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 18, 2007 at 11:13:00AM -0600, Wade Berrier wrote:
> On 10/17/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > On Wednesday 17 October 2007 18:52:28 Wade Berrier wrote:
> > > Another thing I'm noticing is that I can't connect to an 802.11b open
> > > network with a hidden essid.
> > >
> > For those, you should specify the channel, and bssid in one iwconfig command,
> > and then ssid in another command. Everything needs to be specified for hidden
> > networks. Never tried connecting to hidden networks with network manager so I
> > dunno if that's suppose to work.
> 
> I've been able to connect to this hidden network via network manager.
> >From a users experience, I enter in the essid from the "Connect to
> other wireless network" dialog, and it connects.  I'm not sure how
> networkmanager makes the connection between the essid and the ap.

If anything, I usually find that I can connect to the hidden networks
using iwconfig but _not_ with NetworkManager.  FWIW, mac80211 will
send probe requests for unknown SSIDs when trying to associate.

Unfortunately, I'm not really sure how this relates to the problem
you are having.  Perhaps probe responses are being lost somehow?

John
-- 
John W. Linville
linville@tuxdriver.com
