Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41051 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2JSIAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 04:00:54 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so65065bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2012 01:00:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Lopez <jlopex@cozybit.com>
Subject: Re: Receive BlockAckReq and BlockAck on carl9170 driver
Date: Fri, 19 Oct 2012 10:00:41 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAMr9ZPkS3TXg7XDNzeor7zXED7cUUqcGdrb53OFGtr0N8Hh5Ng@mail.gmail.com>
In-Reply-To: <CAMr9ZPkS3TXg7XDNzeor7zXED7cUUqcGdrb53OFGtr0N8Hh5Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210191000.41350.chunkeey@googlemail.com> (sfid-20121019_100057_926684_3B0EA743)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Friday, October 19, 2012 05:57:57 AM Javier Lopez wrote:
> We are trying to receive BlockAckReq and BlockAck on carl9170 driver.
> We've been playing with CARL9170_RX_FILTER_CTL_OTHER and
> CARL9170_RX_FILTER_CTL_BACKR rx filters but we cannot see
> those frames on the traps we have on carl9170_handle_mpdu
> function.
Do you have an example of such a frame trap? And what operation
mode do you use? Normal station, adhoc, AP or mesh? Are the
BA/BARs for directed to the carl9170-device, or are they for
someone else? ---

> Is it not possible to receive those frames on driver?
Do you get these frames on a secondary monitor interface?

Regards,
	Chr
