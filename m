Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33032 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0CSGjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 02:39:24 -0400
Received: by bwz1 with SMTP id 1so2698548bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 23:39:22 -0700 (PDT)
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv3 1/2] cfg80211: Add connection quality monitoring support to nl80211
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	<1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 19 Mar 2010 08:39:19 +0200
In-Reply-To: <1268830877-5162-2-git-send-email-juuso.oikarinen@nokia.com> (Juuso Oikarinen's message of "Wed\, 17 Mar 2010 15\:01\:16 +0200")
Message-ID: <87eijgddd4.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> Add support for basic configuration of a connection quality monitoring to the
> nl80211 interface, and basic support for notifying about triggered monitoring
> events.
>
> Via this interface a user-space connection manager may configure and receive
> pre-warning events of deteriorating WLAN connection quality, and start
> preparing for roaming in advance, before the connection is already lost.

Sorry, I have been busy lately (over 500 unread emails in
linux-wireless, doh!) and I haven't had time to look at your patches
in detail. But I want to emphasise that in the future we want to
extend this interface with new events like beacon loss or
retransmissions. From a quick look your patches make this possible and
that's good.

-- 
Kalle Valo
