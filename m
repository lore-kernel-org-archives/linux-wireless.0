Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pdtms1.pdt.com ([207.18.22.4]:57324 "EHLO mail.pdt.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751823Ab1ACRDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 12:03:37 -0500
From: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: wl1271 status/update
Date: Mon, 3 Jan 2011 17:00:24 +0000
Message-ID: <0826983CC0CB074798C42E77D8ACD07F063277@pdtms1.pdt.com>
References: <0826983CC0CB074798C42E77D8ACD07F0616CB@pdtms1.pdt.com>,<AANLkTimH1aFuBfgD8g50YJjto9Mx3jRaPJMa5veG1o+z@mail.gmail.com>
In-Reply-To: <AANLkTimH1aFuBfgD8g50YJjto9Mx3jRaPJMa5veG1o+z@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Ohad!

I have been looking at this wiki and am confused as to what i exactly
need...

I see things about compat-wireless, mac80211, sdio runtime pm support,
lenient generic runtime pm callbacks,
etc..

I don't really understand.. do i need all of this for wl1271...
is there any high level documentation as to how wl1271 fits into linux/android?

i understand that wl1271 is a chip from TI that supports WLAN, FM, and BT,
but how that equates to what needs to go into linux/android, I'm not understanding...

:-)
Karen
________________________________________
From: Ohad Ben-Cohen [ohad@wizery.com]
Sent: Monday, January 03, 2011 10:49 AM
To: Brzezowski, Karen
Cc: linux-wireless@vger.kernel.org
Subject: Re: wl1271 status/update

Hi Karen,

On Mon, Jan 3, 2011 at 6:02 PM, Brzezowski, Karen
<Karen.Brzezowski@pdt.com> wrote:
> I'm quite confused as to the status of it...
...
> And I appreciate ANY help/information to get me going......

Check out our wiki - it has lots of status and porting information for
the wl12xx driver:

http://wireless.kernel.org/en/users/Drivers/wl12xx

Regards,
Ohad.

> Thanks!
> Karen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Email secured by Check Point
