Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49553 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab0DPNpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 09:45:10 -0400
Date: Fri, 16 Apr 2010 09:37:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH PING] ssb patches for SPROM location
Message-ID: <20100416133711.GB8554@tuxdriver.com>
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 08:20:51AM +0200, Rafał Miłecki wrote:
> John, I posted some time ago following patches:
> 
> [RFT][PATCH] ssb: Look for SPROM at different offset on higher rev CC
> [PATCH 1/2] ssb: Use relative offsets for SPROM
> [PATCH 2/2] ssb: Fix order of definitions and some text space indents
> 
> while Michael has some doubts about "ssb: Look for SPROM at different
> offset on higher rev CC" I explained to him that what he does not like
> was fixed in next 2 posted patches.
> 
> AFAIR you got some device with this recently-discovered location of
> SPROM. Could you test my set if it makes your card working? If so,
> could you take that patches to your tree?

Sorry, been busy w/ other things.  FWIW, my implementation based on
the RE work from Larry did not work on the box in question, and my
implementation wasn't substantially different from yours.  Anyway,
I'll try to confirm this soon w/ your patches and to collect more
information for Larry.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
