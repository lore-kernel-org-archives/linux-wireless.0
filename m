Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0OTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 10:19:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1THEwN-00034O-DH
	for linux-wireless@vger.kernel.org; Thu, 27 Sep 2012 16:19:47 +0200
Message-ID: <1348755619.16494.1.camel@jlt4.sipsolutions.net> (sfid-20120927_161952_444358_4DA73095)
Subject: Re: Need desperate help - wireless 802.1X problem
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 27 Sep 2012 16:20:19 +0200
In-Reply-To: <20120927140923.GA11241@w1.fi>
References: <CAFDG9nueE4Y8MjgDQe5Z6yn6YKBe20D=0Uo4RkQtet+E0BL-Ug@mail.gmail.com>
	 <20120927140923.GA11241@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 17:09 +0300, Jouni Malinen wrote:

> > I need desperate help regarding my wireless connection problem. I
> > cannot connect to my university's wireless network which uses
> > WEP802.1X security.
> 
> I've never tested dynamic WEP keys with iwlwifi and 5100, so I'm not
> sure what to expect from the combination. Anyway, the next step in
> debugging this would be to collect some driver logs.. Sorry to bounce
> you back, but linux-wireless would really be the correct list for this
> ;-).

:-)

Alper, did you actually *unload* the module before trying "modprobe
iwlwifi swcrypto=1"?

Please try
sudo modprobe -r iwlwifi
sudo modprobe iwlwifi swcrypto=1

and see if that helps.

johannes

