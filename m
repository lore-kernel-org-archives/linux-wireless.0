Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43321 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbcFDEum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 00:50:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Prasun Maiti <prasunmaiti87@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: wext: making deprecation more visible
References: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com>
	<1464690345.3076.17.camel@sipsolutions.net>
	<CAEO8o4=-oYuHuh42yfRa6kAUZ2hBmxHabU-W3V82kURg-GZv_g@mail.gmail.com>
	<1464979620.2224.5.camel@sipsolutions.net>
Date: Sat, 04 Jun 2016 07:50:36 +0300
In-Reply-To: <1464979620.2224.5.camel@sipsolutions.net> (Johannes Berg's
	message of "Fri, 03 Jun 2016 20:47:00 +0200")
Message-ID: <87porxlfqb.fsf_-_@purkki.adurom.net> (sfid-20160604_065333_432854_396F87EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I'd blissfully forgotten how totally crufty this API is ... oh well.

Yesterday there was a user on IRC having problems with wext (I didn't
even bother to investigate what exactly) which was immediately solved by
switching to nl80211. But he had no idea that wext was depricated until
I told him.

I know we can't remove wext because of legacy applications but is there
anything more we can do to make the users aware that wext is depreciated
and really should be avoided? For example a onetime kernel warning? Or
is that too spammy? Anything else?

-- 
Kalle Valo
