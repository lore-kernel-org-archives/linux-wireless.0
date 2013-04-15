Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3DONWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 09:22:17 -0400
Message-ID: <1366032132.8361.19.camel@jlt4.sipsolutions.net> (sfid-20130415_152225_366245_D047ABA1)
Subject: Re: Centrino Ultimate-N 6300 AGN rfkill always Soft blocked
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: schwaahed <schwaahed@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Apr 2013 15:22:12 +0200
In-Reply-To: <1365804259.10342.20.camel@dcbw.foobar.com> (sfid-20130413_000245_000077_30E72639)
References: <CAPutgu8mCmfmsEq0jkqtAN25oUBmCxZLW-kTZrsPKFpCfdJU2A@mail.gmail.com>
	 <1365804259.10342.20.camel@dcbw.foobar.com>
	 (sfid-20130413_000245_000077_30E72639)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-12 at 17:04 -0500, Dan Williams wrote:
> On Thu, 2013-04-11 at 20:03 -0400, schwaahed wrote:
> > Hello,
> > 
> > I have an HP Elitebook 8460w laptop containing a Centrino Ultimate-N
> > 6300 AGN (linux-3.8.6 iwlwifi module -  firmware version 9.221.4.1
> > build 25532)
> 
> I notice that your 'rfkill list all' dumps below don't contain an entry
> for hp-wmi.  Is that module loaded on your machine?  It's needed at
> least for earlier models of the Elitebook, up at least until the xx40
> series.  Perhaps it needs to be updated for your laptop?  You might ask
> on the general kernel lists if anyone knows how rfkill is supposed to
> work for the 8460 and if hp-wmi supports it, or if some other mechanism
> is used.

Yeah it seems not loaded, but how then does the soft block affect hard
block? All very odd, but almost certainly a platform rather than a wifi
issue. 

johannes

