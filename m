Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f198.google.com ([209.85.221.198]:65306 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0CDCfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 21:35:47 -0500
Received: by qyk36 with SMTP id 36so1599296qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 18:35:46 -0800 (PST)
Message-ID: <4B8F1C7F.7050305@lwfinger.net>
Date: Wed, 03 Mar 2010 20:35:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Daniele C." <legolas558@users.sourceforge.net>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: rt2870 (staging kernel driver) crashes fatally
References: <4B8E20CF.50109@users.sourceforge.net> <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com>
In-Reply-To: <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/2010 08:14 PM, Hin-Tak Leung wrote:
> You appear to have two issues - (1) the driver doesn't
> hibernate/resume well, (2) there is some bad memory leak which causes
> your system to run out of memory.
> 
> You did not mention issue (1) - that you were hibernating and resuming
> (and expecting it to work, which it does not). For the latter, you
> probably need to track down where the memory is leaking in the driver,
> which is probably easier than tracking down the hibernate/resume
> issue.
> 
> Good luck with tracking down the memory leak. (you do understand that
> staging drivers are DIY - i.e. you try it only if you are willing to
> look into fixing it yourself - I hope )

By generating your own kernel with MEMLEAK enabled, you should be able to see
which data blob is being leaked. If you post that info, someone on this list
should be able to help you find the cause.

Larry


