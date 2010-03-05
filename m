Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212]:42682 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0CEQWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 11:22:48 -0500
Received: by ewy4 with SMTP id 4so2552847ewy.28
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 08:22:47 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rt2870 (staging kernel driver) crashes fatally
Date: Fri, 5 Mar 2010 17:22:41 +0100
Cc: "Daniele C." <legolas558@users.sourceforge.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <4B8E20CF.50109@users.sourceforge.net> <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com> <4B8F1C7F.7050305@lwfinger.net>
In-Reply-To: <4B8F1C7F.7050305@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003051722.42437.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 04 March 2010, Larry Finger wrote:
> On 03/03/2010 08:14 PM, Hin-Tak Leung wrote:
> > You appear to have two issues - (1) the driver doesn't
> > hibernate/resume well, (2) there is some bad memory leak which causes
> > your system to run out of memory.
> > 
> > You did not mention issue (1) - that you were hibernating and resuming
> > (and expecting it to work, which it does not). For the latter, you
> > probably need to track down where the memory is leaking in the driver,
> > which is probably easier than tracking down the hibernate/resume
> > issue.
> > 
> > Good luck with tracking down the memory leak. (you do understand that
> > staging drivers are DIY - i.e. you try it only if you are willing to
> > look into fixing it yourself - I hope )
> 
> By generating your own kernel with MEMLEAK enabled, you should be able to see
> which data blob is being leaked. If you post that info, someone on this list
> should be able to help you find the cause.

Actually the rt2x00-users list is not intended for the Ralink staging drivers.
You have to use the staging mailing list: devel@driverdev.osuosl.org

Ivo
