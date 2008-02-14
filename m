Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4263 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbYBNOcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 09:32:13 -0500
Date: Thu, 14 Feb 2008 08:56:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Adam Turk <bofh1234@hotmail.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Message-ID: <20080214135635.GA2981@tuxdriver.com> (sfid-20080214_143219_083995_8C30BB19)
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl> <1202952347.29519.5.camel@dv> <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl> <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 14, 2008 at 10:49:34AM +0100, Ivo Van Doorn wrote:
> Hi,
> 
> >  phy0: Failed to initialize wep
> 
> I see this message popping up more frequently lately.
> 
> Do any of the mac80211 people know when and why mac80211
> fails to load the wep module?
> Is there some dependency missing for mac80211?

I don't know, but it seems like there must be something like that.
It might be helpful to post the .config for the failing kernel?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
