Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16726 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab0EXWac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 18:30:32 -0400
Subject: Re: Iwlwifi and LEDS?
From: reinette chatre <reinette.chatre@intel.com>
To: Gregy <p.gregy@gmail.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	 <1274465242.12391.0.camel@abhi-desktop>
	 <AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 15:30:31 -0700
Message-ID: <1274740231.2091.15472.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-21 at 13:49 -0700, Gregy wrote:
> On 21 May 2010 20:07, Abhijeet Kolekar <abhijeet.kolekar@intel.com> wrote:
> > On Fri, 2010-05-21 at 02:11 -0700, Gregy wrote:
> >> Hello, I noticed you removed support for led subsystem from iwlwifi. I
> >> have used it to control wifi led from userspace. Is it still possible
> >> somehow?
> >>
> > There is module parameter for iwlcore called 'led_mode'.
> 
> Yes but I cannot control the led through it. I can only set one of two
> modes. Before I could  use it as "connected to internet" indicator or
> I could turn it off completely.

No - we did not remove support for LEDs from iwlwifi. The led_mode
module parameter is just to change the blinking behavior (0=blinking,
1=On(RF On)/Off(RF Off)).

What did you do before that does not work anymore?

Reinette


