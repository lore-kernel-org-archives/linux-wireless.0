Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:53599 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab0KRRIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 12:08:04 -0500
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <4CE55C3B.6020803@lwfinger.net> (sfid-20101118_180314_721728_2D534AE3)
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
	 <1288823326-9686-2-git-send-email-zajec5@gmail.com>
	 <20101116212321.GF10774@tuxdriver.com> <1290013976.2513.14.camel@maggie>
	 <20101118162748.GB2468@tuxdriver.com> <1290098156.12596.2.camel@maggie>
	 <AANLkTimh_8X1uRPudmQLDOTeA_X0ciR9BbDgyahLDMSs@mail.gmail.com>
	 (sfid-20101118_174421_892253_3B53C8D3) <1290098865.12596.6.camel@maggie>
	 <4CE55C3B.6020803@lwfinger.net> (sfid-20101118_180314_721728_2D534AE3)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 18:07:55 +0100
Message-ID: <1290100075.12596.8.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 11:02 -0600, Larry Finger wrote: 
> On 11/18/2010 10:47 AM, Michael Büsch wrote:
> > If it would really succeed to initialize the device, this would be a
> > regulatory issue, because the sprom contains various power amplifier
> > calibration data. I think it should rather fail and be fixed correctly
> > instead of incorrectly using rev1 in that case.
> 
> I agree that it is better to fail than use incorrect power data.
> 
> Would it be useful if the SPROM data were logged when the revision is crap?


We need to keep in mind that there will be no new SSB devices.
It seems pretty much EOL'ed by Broadcom.
So I'm not sure whether this would be of any use or just random dead
code.

-- 
Greetings Michael.

