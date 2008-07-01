Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54021 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbYGARfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 13:35:16 -0400
Date: Tue, 1 Jul 2008 14:35:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080701173502.GB24605@khazad-dum.debian.net> (sfid-20080701_193520_927033_DE544945)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <200807011227.15805.mb@bu3sch.de> <20080701143439.GA6962@khazad-dum.debian.net> <1214923097.3462.0.camel@johannes.berg> <20080701165036.GB6962@khazad-dum.debian.net> <1214931676.3462.5.camel@johannes.berg> <486A65F5.5030909@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <486A65F5.5030909@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 Jul 2008, Larry Finger wrote:
> On my HP laptop using the RFKILL code currently in wireless-testing,  
> sliding the "Wireless switch" results in b43_rfkill_poll being called.  

Can you confirm (remove rfkill-input, hp-wmi, and anything else that could
mess with the results) that the HP laptop wireless switch is wired directly
to that b43 input pin?

Is it wired to anything else? e.g. can hp-wmi see that switch?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
