Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43297 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZB0TUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 14:20:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Fwd: b43* linux driver, more ids dev
Date: Fri, 27 Feb 2009 20:19:08 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <ee588a540902270946h13e03b6el71de5237a458b7a3@mail.gmail.com> <49A83765.30202@lwfinger.net> <49A83BC5.2020204@gmail.com>
In-Reply-To: <49A83BC5.2020204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902272019.08275.mb@bu3sch.de> (sfid-20090227_202056_744607_8FE8DAE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 February 2009 20:15:17 Xose Vazquez Perez wrote:
> Larry Finger wrote:
> 
> > Xose Vazquez Perez wrote:
> > 
> >> are there any trouble with these devices ? why are they not  inside
> >> b43* drivers ?
> >>
> >> PCI_VENDOR_ID_BROADCOM, 0x4313
> >> PCI_VENDOR_ID_BROADCOM, 0x4315
> >> PCI_VENDOR_ID_BROADCOM, 0x432a
> >> PCI_VENDOR_ID_BROADCOM, 0x432b
> >> PCI_VENDOR_ID_BROADCOM, 0x432c
> >> PCI_VENDOR_ID_BROADCOM, 0x432d
> > 
> > Those devices are either LP PHY (4315 and probably 4313) or N PHY (432X)
> > devices. The reverse engineering for the LP PHY was just completed, but the code
> > is not yet written. The RE for the N PHY has barely begun.
> > 
> > Once there is code to drive those devices, their ID's will be added.
> 
> It smells like another crap_driver for staging tree.
> 

No it doesn't. It is closed source.
Please read the documentation before posting the next mail. Thanks.

-- 
Greetings, Michael.
