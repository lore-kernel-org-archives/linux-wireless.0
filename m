Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3FRPxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:53:32 -0400
Message-ID: <1371570798.22256.1.camel@jlt4.sipsolutions.net> (sfid-20130618_175336_131118_FFF62E11)
Subject: Re: [PATCHv3 07/18] mac80211: add radiotap flag and handling for
 5/10 MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 18 Jun 2013 17:53:18 +0200
In-Reply-To: <20130618155051.GD27492@pandem0nium>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368702045-27598-8-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371565626.8318.26.camel@jlt4.sipsolutions.net>
	 <20130618155051.GD27492@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 17:50 +0200, Simon Wunderlich wrote:

> Hmm, if this [1] is the official standard, then no, it is not defined. Don't
> know when this was added in wireshark, and it was only added implicitly in
> the code (no header files etc). But since it was there, I figured it would
> be a good idea to re-use it (unaware that there was some "standard").
> 
> How shall we proceed, propose that on some radiotap mailing list officially?

Yes, see http://www.radiotap.org/Standardisation

> > > +	RX_FLAG_10MHZ			= BIT(26),
> > > +	RX_FLAG_5MHZ			= BIT(27),
> > 
> > Does that make sense? We know what kind of channel we're on? Though it
> > might be easier for the driver, so it may make sense I guess.
> 
> Yeah, it's a little easier for the driver, and I thought it would be
> cleaner to get this reported through a flag.

Yeah I tend to agree.

johannes

