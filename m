Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:42299 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZEROpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 10:45:14 -0400
Received: by ewy24 with SMTP id 24so4113509ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 07:45:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Alexandre Becholey <alexandre@shockfish.com>
Subject: Re: [PATCH]rt73usb: fix for master mode.
Date: Mon, 18 May 2009 16:45:12 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch> <200905181531.37484.IvDoorn@gmail.com> <4A1173D1.5010704@shockfish.com>
In-Reply-To: <4A1173D1.5010704@shockfish.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905181645.12891.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Also have you considered the following things:
> > 	RTS frames success/failure reporting?
> > 	tx_success/tx_failure statistics counters (used in link_tuner as well)
> >
> > Thanks,
> >
> > Ivo
> >   
> Ok I'll do it, but how should I treat the status unknown for the 
> statistics? as a success?

yeah, since it will be reported as success to mac80211 as well,
it only makes sense to handle it in the statistics as such as well.

Ivo
