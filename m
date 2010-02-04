Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:43749 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab0BDJHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 04:07:07 -0500
Received: by ewy28 with SMTP id 28so2567037ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 01:07:06 -0800 (PST)
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] mac80211: Retry null data frame for power save.
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 04 Feb 2010 11:00:42 +0200
In-Reply-To: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com> (Vivek Natarajan's message of "Thu\, 4 Feb 2010 12\:24\:01 +0530")
Message-ID: <87ljf9jryd.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> Even if the null data frame is not acked by the AP, mac80211 goes
> into power save. This might lead to loss of frames from the AP.
> Prevent this by restarting dynamic_ps_timer when ack is not received
> for null data frames.

Yes, this is definitely needed. I like the idea, but I will check the
patch in detail later today.

-- 
Kalle Valo
