Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:38338 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751505AbYHHRdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 13:33:13 -0400
Date: Fri, 8 Aug 2008 13:33:11 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: N protocol on 802.11a freq signal strength
Message-ID: <20080808173311.GA29952@bromo.msbb.uc.edu> (sfid-20080808_193316_586247_0338BA3F)
References: <20080808141616.GA26224@bromo.msbb.uc.edu> <43e72e890808080949l1ee7a392m784fe06a3611e9ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890808080949l1ee7a392m784fe06a3611e9ba@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,
   Is there a wiki explanation of aggregation somewhere? As for the
option key trick, when you hold down the option key while clicking
on the Airport menu bar icon in the Finder, the dropdown menu that
displays the available wireless networks is expanded to show detailed
information for the current wireless connection (speed, SN in dB,
channel, etc).
                    Jack

On Fri, Aug 08, 2008 at 09:49:15AM -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 8, 2008 at 7:16 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> >    After replacing my Linksys WRT150N wireless router with an
> > Apple Airport Extreme Gigabit ethernet wireless router, configured
> > for using the N protocols on the 802.11a wireless frequencies, I
> > can confirm that the ath9k git from last week connects to this
> > configuration. I have noticed one oddity though. The reported
> > signal strength (in the NetworkManager menu bar icon) is significantly
> > lower than that shown under Mac OS X 10.5.
> 
> The link quality we report right now should be lower than the real
> one. We will enhance this later but rest assured its the same.
> 
> > Also, I notice under Mac OS X
> > 10.5, by holding the option key on the Finder's Airport icon, that the
> > transmit speed is 300 Mbps when the MacBook Pro is in the same room as
> > the wireless router but only 108 Mbps when a couple rooms away. Should
> > the ath9k report such dynamic changes in transmit speed? Under Mac OS X
> > that transmit speed changes as I move the portable back and forth
> > between the two locations. Thanks in advance for any information.
> 
> Keep in mind 2.6.27 has aggregation disabled right now due to the new
> TX MQ changes so you won't be able to get aggregation going for any
> 11n wireless device. That said, I am not familiar with the Mac OS X
> option key thingy to compute throughput. If you can provide technical
> details as to how it computes it or where it does this (AP or STA) it
> can help.
> 
>   Luis
