Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42675 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbZJZHTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 03:19:00 -0400
Received: by ewy4 with SMTP id 4so3338737ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 00:19:03 -0700 (PDT)
To: belle.shi@yy.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: about 802.11 scan and probe request
References: <20091026103247.2ng5wbub4ow8ok4w@webmail.yy.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 09:19:01 +0200
In-Reply-To: <20091026103247.2ng5wbub4ow8ok4w@webmail.yy.com> (belle shi's message of "Mon\, 26 Oct 2009 10\:32\:47 +0800")
Message-ID: <87y6myhbbu.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

belle.shi@yy.com writes:

> there is one question: the scan have two mode:active or passive,but
> when i run the wpa_gui, there is only scan button

Passive scan is so slow that we want to use active scan always when
possible. No need to confuse users about this, so one scan button is
enough.

> i think the active scan is to send Probe Request frame, and the
> passive scan to receive the beacon frame, is it right?

Correct.

-- 
Kalle Valo
