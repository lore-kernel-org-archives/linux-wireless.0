Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51347 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZKJIAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 03:00:44 -0500
Received: by ewy3 with SMTP id 3so3966128ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 00:00:48 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: Supply additional parameters to at76_start_monitor scan request
References: <1257724939.21194.926.camel@rainbow>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 10 Nov 2009 10:00:46 +0200
In-Reply-To: <1257724939.21194.926.camel@rainbow> (Jason Andryuk's message of "Sun\, 08 Nov 2009 19\:02\:19 -0500")
Message-ID: <87fx8merm9.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> For my Linksys WUSB11 at76c503-i3861 device, scanning fails without
> probe_delay, min_channel_time, and max_channel_time specified for the
> scan request.  These values were found by checking scan requests from
> the at76_usb driver.
>
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>

Thank you for finding this.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
