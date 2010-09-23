Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39676 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0IWMwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:52:49 -0400
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Robert Nelson <robertcnelson@gmail.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <AANLkTimce-=MP2DDNTpRh_oRFW15_gSkKZJ6fQzwc4yJ@mail.gmail.com>
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
	 <AANLkTinLjQbvbTj3LTnw+54S-ojWzojqgyd=-3F783We@mail.gmail.com>
	 <AANLkTimce-=MP2DDNTpRh_oRFW15_gSkKZJ6fQzwc4yJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 15:52:33 +0300
Message-ID: <1285246353.3231.84.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 14:03 +0200, ext Robert Nelson wrote:
> On Thu, Sep 23, 2010 at 5:30 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> > On Thu, Sep 23, 2010 at 11:20 AM, Luciano Coelho
> > <luciano.coelho@nokia.com> wrote:
> >> Add board configuration for the wl1271 daughter board.  This patch is based
> >> on Ohad Ben-Cohen's patches for Zoom boards.
> >
> > Hm can that daughter board be detected? With your patch all beagle
> > users will get GPIO139 toggled, and if someone has that wired to
> > chainsaw switch somebody might get hurt.
> 
> Expansion boards really need to follow:
> 
> http://elinux.org/BeagleBoardPinMux#Expansion_boards
> 
> Is there any eeprom on i2c bus #2 for identification on this board?

Hmmm... <checking the schematics>

Yes, it does. :) This makes perfect sense.

My bootloader (U-Boot 2010.03) doesn't seem to detect it, though:

<clip>
Probing for expansion boards, if none are connected you'll see a
harmless I2C error.

No EEPROM on expansion board
<clip>

Do I need a special bootloader?

Is there any standard way to recognize the expansion board and configure
it properly?

-- 
Cheers,
Luca.

