Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:35317 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0BSQkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 11:40:47 -0500
Received: by gxk9 with SMTP id 9so254055gxk.8
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 08:40:47 -0800 (PST)
Message-ID: <4B7EBF0A.1060907@lwfinger.net>
Date: Fri, 19 Feb 2010 10:40:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs definitions
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>	 <1266591292.15178.1.camel@jlt3.sipsolutions.net>	 <4B7EB31D.2000603@lwfinger.net> <1266596602.15178.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266596602.15178.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2010 10:23 AM, Johannes Berg wrote:
> 
> Right. I was also wondering if it is showing signs of life yet? Mine has
> device version that also needs minor SSB adjustments still.

Thanks for the update on the link. I pulled it out of a previous E-mail rather
than using Google to find it again.

Rafał is taking exams now, but said in one of our last communications that he
was finishing up some radio code. After that, he expected some signs of life.

What PHY revision do you have? Between 2 and 3 there were a lot of changes
including a new radio version. Rafał has a 2, thus he has been concentrating on
that one.

Do you have any log messages on the SSB adjustments?

Larry
