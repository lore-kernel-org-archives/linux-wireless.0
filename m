Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1KUR0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 12:26:39 -0500
Subject: Re: [PATCHv3 3/3] mac80211: Add NoAck per tid Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <87mxbpie8o.fsf@purkki.adurom.net>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1321614110-32392-4-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1321614744.10266.37.camel@jlt3.sipsolutions.net>
	 <20111118123054.GA32175@pandem0nium>  <87mxbpie8o.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 18:26:33 +0100
Message-ID: <1321896393.3999.53.camel@jlt3.sipsolutions.net> (sfid-20111121_182642_329960_B9CE0CC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 19:20 +0200, Kalle Valo wrote:
> Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> writes:
> 
> >> Isn't this missing an update to ieee80211_duration() now?
> >
> > Yep, I silently dropped that modification - I rather don't mess with stuff I
> > don't completly understand. Keeping the duration too long shouldn't hurt
> > (only performance), having it too short will have much worse effects ...
> 
> Still a comment in the function about this issue would be nice. Just to
> make sure that it's not forgotten.

I think it should be added back -- it doesn't seem that hard? Just check
if (qos_data && no-ack)? It's on my list but I haven't gotten around ...

johannes


