Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41117 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1KURUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 12:20:47 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv3 3/3] mac80211: Add NoAck per tid Support
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1321614110-32392-4-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1321614744.10266.37.camel@jlt3.sipsolutions.net>
	<20111118123054.GA32175@pandem0nium>
Date: Mon, 21 Nov 2011 19:20:39 +0200
In-Reply-To: <20111118123054.GA32175@pandem0nium> (Simon Wunderlich's message
	of "Fri, 18 Nov 2011 13:30:54 +0100")
Message-ID: <87mxbpie8o.fsf@purkki.adurom.net> (sfid-20111121_182050_513052_26500E73)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> writes:

>> Isn't this missing an update to ieee80211_duration() now?
>
> Yep, I silently dropped that modification - I rather don't mess with stuff I
> don't completly understand. Keeping the duration too long shouldn't hurt
> (only performance), having it too short will have much worse effects ...

Still a comment in the function about this issue would be nice. Just to
make sure that it's not forgotten.

-- 
Kalle Valo
