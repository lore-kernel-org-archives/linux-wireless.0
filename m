Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13443 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab0EMRxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 13:53:03 -0400
Date: Thu, 13 May 2010 10:52:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Matt Chen <machen@novell.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Joey Lee <jlee@novell.com>, Gary Lin <GLin@novell.com>,
	Greg Kroah-Hartman <GregKH@novell.com>,
	"linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Fix AR9285 always turn off LED on HP mini 210 [1/1]
Message-ID: <20100513175254.GI2354@tux>
References: <4BE67B370200002300018B53@novprvlin0050.provo.novell.com>
 <20100510182139.GD2177@tux>
 <AANLkTikDcu0vDdThckqunFEa1bPzkfxhpwyql-wKdU8Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTikDcu0vDdThckqunFEa1bPzkfxhpwyql-wKdU8Z@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 04:13:18AM -0700, Matt Chen wrote:
> Hi Luis,
> Tried the driver,compat-wireless-2.6.33.
> 2.tar.bz2,  from http://wireless.kernel.org/en/users/Download/stable, it doesn't fix this issue. The LED is still keeping off whatever you enable/disable it.

2.6.33 is ancient now, try the compat-wireles 2.6.34-rc stuff and if
that doesn't help try bleeding edge. The fixes need to be addressed
on bleedinge edge *first* but if bleedinge edge already has a fix
then its a matter of cherry picking that and sending it to the stable
gods.

  Luis
