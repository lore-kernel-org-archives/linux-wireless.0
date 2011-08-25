Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4785 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab1HYR7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:59:11 -0400
Date: Thu, 25 Aug 2011 10:59:04 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110825175903.GD2058@broadcom.com> (sfid-20110825_195915_072529_90DDF1A3)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com>
 <20110825002032.GA7577@broadcom.com>
 <CAOiHx=narxG2WG1+8jDTah=u=XQ337K7UZZgd8Fv9xksufkEKw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOiHx=narxG2WG1+8jDTah=u=XQ337K7UZZgd8Fv9xksufkEKw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 03:34:52AM -0700, Jonas Gorski wrote:
> > I believe the only SB bus functions that brcmfmac uses are the core reset and
> > disable functions, and only when initializing the chip to download firmware
> > (all other management of the bus is handled by the on-chip CPU).  Is it
> > possible to use those funtions from ssb, without the ssb module trying to
> > manage the bus?
> 
> I haven't really looked at how much the brcmfmac driver uses ssb; I
> just saw s(s)b_* stuff in there and remembered that ssb supports SDIO
> host, so I assumed that there's part of the stack hidden in brcmfmac.
> But if it's only core reset and disable, then what Michael said
> applies ;-)

Yes, I was doubting there would be much benefit, but didn't have a strong
opinion either way.

Thanks for the feedback.

- Henry

