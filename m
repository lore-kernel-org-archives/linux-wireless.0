Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40830 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab3A2NCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 08:02:30 -0500
Message-ID: <1359464487.15280.4.camel@cumari.coelho.fi> (sfid-20130129_140233_789042_EA698DA4)
Subject: Re: [PATCH 34/37] iwlwifi: add the MVM driver (time-event.h)
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Tue, 29 Jan 2013 15:01:27 +0200
In-Reply-To: <1359365864-4259-35-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
	 <1359365864-4259-35-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-28 at 10:37 +0100, Johannes Berg wrote:

[...]

> + /**
> + * DOC: The flow against the fw
> + *
> + * When the driver needs to make sure we are in a certain, at a certain time

I was reading this and noticed a couple of small things. ;)

s/we are in a certain,/we are in a certain channel,/


> + * and for a certain duration, it sends a Time Event. The flow against the fw
> + * goes like this:
> + *	1) Driver sends a TIME_EVENT_CMD to the fw
> + *	2) Driver gets the response for that command. This response contains the
> + *	   Unique ID (UID) of the event.
> + *	3) The fw sends notification when the event start.

s/start/starts/


> + * Of course the API provides various options that allows to cover parameters

s/allows/allow/

--
Luca.

