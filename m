Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2923 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbYEMMwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:52:44 -0400
Date: Tue, 13 May 2008 08:30:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>, Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: 11n + wpa_supplicant
Message-ID: <20080513123001.GA3279@tuxdriver.com> (sfid-20080513_145246_963681_55C6891A)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com> <1210667328.3646.24.camel@johannes.berg> <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com> <1210668421.3646.43.camel@johannes.berg> <8704f27d0805130148t57a1dad5nf5ff535ae4ddf968@mail.gmail.com> <1210670248.3646.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1210670248.3646.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 11:17:28AM +0200, Johannes Berg wrote:
> 
> > >  Ah, so you mean if the user chose TKIP then we should associate as a
> > >  legacy STA?
> > >
> > 
> > I think so... If the AP is N-only we would be in trouble...
> 
> Hm. I don't really see much reason to do this. Technically, you could
> configure it this way, but in practice most people will just enable all
> algorithms they can support (i.e. all).
> 
> I don't really care, but I wouldn't want to complicate wext further for
> this.

Amen to that...

-- 
John W. Linville
linville@tuxdriver.com
