Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43497 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbcDZKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 06:00:05 -0400
Message-ID: <1461664802.16188.8.camel@sipsolutions.net> (sfid-20160426_120015_744711_08D7CC49)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	Radu P <rrrpan@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Apr 2016 12:00:02 +0200
In-Reply-To: <CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com> (sfid-20160426_105622_788471_B17C5A90)
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	 <CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	 (sfid-20160426_105622_788471_B17C5A90)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-26 at 02:56 -0600, Reinoud Koornstra wrote:
> I'm also using the 7620 AC.
> When I type:
> 
> sudo iw dev wlp0s4 scan I see:
> 

"scan" is completely irrelevant for what actually ends up getting used.
"link" is relevant, but if you want to see the hardware capabilities
(like what iwconfig is displaying - that field has no relation to the
connection at all) then you need "iw list" or so.

johannes
