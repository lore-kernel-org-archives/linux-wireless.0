Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web32505.mail.mud.yahoo.com ([68.142.207.215]:21851 "HELO
	web32505.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933123AbZJGCHK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 22:07:10 -0400
Message-ID: <911923.95402.qm@web32505.mail.mud.yahoo.com>
Date: Tue, 6 Oct 2009 19:06:28 -0700 (PDT)
From: Ahmed A <ahmedcali@yahoo.com>
Subject: Re: Linux wifi development board
To: David Acker <dacker@roinet.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4ACB42CB.7010403@roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 10/6/09, David Acker <dacker@roinet.com> wrote:

> From: David Acker <dacker@roinet.com>
> Subject: Re: Linux wifi development board
> To: "Ahmed A" <ahmedcali@yahoo.com>
> Cc: linux-wireless@vger.kernel.org
> Date: Tuesday, October 6, 2009, 6:14 AM
> Ahmed A wrote:
> > Hello,
> > 
> > I have been looking online for a Linux wifi
> development board.  I have come across a few from small
> companies (reasonably priced), but most of those companies
> seem to be out of business.  I would appreciate
> suggestions from anyone that may have used one recently, or
> suggest a link where I can more info some popular ones.
> > 
> > I am mostly interested in doing some software
> development, prototyping on the "application processor", not
> on the "baseband processor" (radio part).
> > 
> > If there is an alternate mailing list I can post my
> question, I would appreciate that also.
> 
> I have had good luck with boards from Gateworks, http://www.gateworks.com/ and radios from Ubiquiti, http://ubnt.com/
> . All of it is supported by OpenWRT, although I believe that
> the gw2348-4 (avila) has mainline support.
> -ack
> 

Hi David,

Thank you for your response.  I would like to explain what I am trying to setup, and would appreciate your feedback please.  My setup would comprise of two parts. One part would be the wifi router (base station), on which I load linux image bundled with my special app onto it.  The other part would be the wifi client (CPE), that would connect to the router.  I would also like to be able to load my own kernel image bundled with my special app.

I am guessing from your email, I would have to get a board from gateworks, hook up an antenna to it from ubnt, load image from OpenWRT, that would be my wifi router.  Is that right? Which product would you recommend, the Avilla platform? Which antenna from ubnt?  Would there be issues getting these to work?  How about the components on the client side, same deal?

I have done some work/programming on the IXP, but I do prefer a board with non-IXP CPU, like PowerPC or XScale.

Is there any solution out there, where the dev board and antenna come bundled, so I don't have to muck around getting them to work?

Any decent alternate board supplier, the prices of boards from gateworks are a bit pricey for me.

Thank you,
Ahmed A.



      
