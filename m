Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54273 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533AbZKYIhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 03:37:15 -0500
Received: by bwz27 with SMTP id 27so6691083bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 00:37:20 -0800 (PST)
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH] mac80211: Send null data frame after disabling power save in Tx path.
References: <1259132754-18164-1-git-send-email-vnatarajan@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Nov 2009 10:37:17 +0200
In-Reply-To: <1259132754-18164-1-git-send-email-vnatarajan@atheros.com> (Vivek Natarajan's message of "Wed\, 25 Nov 2009 12\:35\:54 +0530")
Message-ID: <87zl6b9f0i.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> For drivers setting IEEE80211_HW_PS_NULLFUNC_STACK, a null data frame
> with PM bit off has to be sent before sending normal data frames.

Why? Sending a data frame with PM bit off should be enough to inform
AP that the client is awake.

-- 
Kalle Valo
