Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:39273 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab3AZRJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 12:09:25 -0500
Date: Sat, 26 Jan 2013 18:09:48 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 2/4] rt2x00: remove NOTICE
Message-ID: <20130126170948.GA5834@localhost.localdomain> (sfid-20130126_180930_983929_889B3113)
References: <20130124205931.GB16252@localhost.localdomain>
 <20130124210028.GA22800@localhost.localdomain>
 <CAOZOX0Vj-T1WPHR692LwpSdHontVq5PJG4UJAzg7O=nYLodXOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOZOX0Vj-T1WPHR692LwpSdHontVq5PJG4UJAzg7O=nYLodXOA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 01:28:44PM +0100, Ivo Van Doorn wrote:
> On Thu, Jan 24, 2013 at 10:00 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> > We use this macro only on 3 places - remove it and replace by other
> > appropriate macros for printing messages.
> >
> > Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> > ---
> >  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
> >  drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
> >  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
> >  3 files changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index a1de95e..1791260 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -80,7 +80,7 @@ static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
> >             rt2x00_rf(rt2x00dev, RF3022))
> >                 return true;
> >
> > -       NOTICE(rt2x00dev, "Unknown RF chipset on rt305x\n");
> > +       INFO(rt2x00dev, "Unknown RF chipset on rt305x\n");
> >         return false;
> >  }
> 
> Isn't this more a warning?

Yeah, I'll change that patch.

Stanislaw
