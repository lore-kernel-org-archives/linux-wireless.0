Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:34636 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZERNbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 09:31:39 -0400
Received: by ewy24 with SMTP id 24so4052443ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 06:31:39 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Alexandre Becholey <alexandre.becholey@epfl.ch>
Subject: Re: [PATCH]rt73usb: fix for master mode.
Date: Mon, 18 May 2009 15:31:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch>
In-Reply-To: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905181531.37484.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 May 2009, Alexandre Becholey wrote:
> Report status unknown as if there were successfully transmitted.
> This will avoid hostapd to disassociate because it doesn't understand what a status unknown is.
> 
> Signed-off-by: Alexandre Becholey <alexandre.becholey@epfl.ch>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Please put your patches inline, and CC me for rt2x00 related patches.

As for the patch it seems like you indented with spaces rather then tabs?
And please put the comment inside the else statement rather then breaking
the if-elseif-elseif list.

Also have you considered the following things:
	RTS frames success/failure reporting?
	tx_success/tx_failure statistics counters (used in link_tuner as well)

Thanks,

Ivo




