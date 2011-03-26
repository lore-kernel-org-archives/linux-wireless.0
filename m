Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40992 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1CZNAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2011 09:00:48 -0400
Received: by iwn34 with SMTP id 34so1977870iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2011 06:00:47 -0700 (PDT)
Message-ID: <4D8DE37B.80907@lwfinger.net>
Date: Sat, 26 Mar 2011 08:00:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mattias Nissler <mattias.nissler@gmx.de>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>,
	"Mark (The Wirie)" <mark@thewirie.com>
Subject: Re: Question about code in rc80211_pid_algo.c
References: <4D8D5FEF.6010009@lwfinger.net> <1301140250.3807.5.camel@kea>
In-Reply-To: <1301140250.3807.5.camel@kea>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2011 06:50 AM, Mattias Nissler wrote:
>
> I agree with your analysis, the code will effectively set tmp to zero. I
> would consider this a bug :) The whole differences computation business
> is Stefano's invention though. IIRC, his idea was that we should not
> have a static ordering of rates, but rather learn the order of rates in
> terms of achievable TX rate. I guess you really want to check with him
> in order to find out what to do :)

Hi Mattias,

Thanks for responding. I saw from "git blame" that Stefano had added that part 
of the code, but it has been a long time since he has participated on the lists. 
I'm not sure that he will see this.

I'll try to figure out what might have been meant by that code.

Larry
