Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55306.mail.re4.yahoo.com ([206.190.58.185]:22845 "HELO
	web55306.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751837AbZJYASo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 20:18:44 -0400
Message-ID: <256236.23563.qm@web55306.mail.re4.yahoo.com>
Date: Sat, 24 Oct 2009 17:18:48 -0700 (PDT)
From: X Xiao <austinxxh-linux@yahoo.com>
Reply-To: austinxxh-linux@yahoo.com
Subject: Re: Wrong BSSID generation in IBSS mode with ath5k
To: =?utf-8?B?S2Fyb2wgUHVjecWEc2tp?= <kpucynski@7bulls.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0910241627i5dec6d33g57af6a1104bce91c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

there was  a patch fixed that, it's on the list a few days back.

--- On Sat, 10/24/09, Nick Kossifidis <mickflemm@gmail.com> wrote:

> From: Nick Kossifidis <mickflemm@gmail.com>
> Subject: Re: Wrong BSSID generation in IBSS mode with ath5k
> To: "Karol Pucyński" <kpucynski@7bulls.com>
> Cc: linux-wireless@vger.kernel.org
> Date: Saturday, October 24, 2009, 6:27 PM
> 2009/10/20 Karol Pucyński <kpucynski@7bulls.com>:
> > Hi
> >
> > I have IBSS network (based on ath5k cards).
> > With the same channel/essid set cards often can't
> "negotiate" the
> > same BSSID. Two nodes beside each other both create
> new IBSS networks
> > and they are not trying to merge.
> > Workaround: forcing BSSID with iw does work.
> >
> > Do you know what can be the reason of this problem?
> >
> > Tested on 2.6.31 kernel. May be related to my earlier
> problem 'ath5k
> > IBSS fixed rate'...
> >
> > Best regards
> > --
> > Karol Pucyński
> > 7bulls.com Sp. z o.o.
> > kpucynski@7bulls.com
> >
> 
> In my tests i had to force a scan on one of the cards (so
> that it
> knows what cells are active) and then set the essid. Does
> that work
> for you ?
> 
> -- 
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
