Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40871 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYGAQuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 12:50:40 -0400
Date: Tue, 1 Jul 2008 13:50:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080701165036.GB6962@khazad-dum.debian.net> (sfid-20080701_185044_205132_31C7D270)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <200807011227.15805.mb@bu3sch.de> <20080701143439.GA6962@khazad-dum.debian.net> <1214923097.3462.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214923097.3462.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 Jul 2008, Johannes Berg wrote:
> > 1. It has an input pin that sometimes people connect buttons/switches
> > to.
> > 
> > Does that input pin act as an input for a FLIP-FLOP (and that flip-flop
> > output is the hardware rfkill line), or is it the hardware rfkill line
> > itself?
> 
> Neither. It's not hw kill, but it's not just edge detect either, it does
> have 'kill' and 'not kill' states.

What exactly the input pin does?  what exactly the hardware does when
the input pin state changes?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
