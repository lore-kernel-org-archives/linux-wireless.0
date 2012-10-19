Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52316 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2JSD56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 23:57:58 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so44370oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2012 20:57:57 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 20:57:57 -0700
Message-ID: <CAMr9ZPkS3TXg7XDNzeor7zXED7cUUqcGdrb53OFGtr0N8Hh5Ng@mail.gmail.com> (sfid-20121019_055803_475536_CC23A96F)
Subject: Receive BlockAckReq and BlockAck on carl9170 driver
From: Javier Lopez <jlopex@cozybit.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

We are trying to receive BlockAckReq and BlockAck on carl9170 driver.
We've been playing with CARL9170_RX_FILTER_CTL_OTHER and
CARL9170_RX_FILTER_CTL_BACKR rx filters but we cannot see those frames
on the traps we have on carl9170_handle_mpdu function.

Is it not possible to receive those frames on driver? Are we missing something?

I'm using latest carl9170-fw from chunkeey github.
And 3.5.y branch from compat-drivers.

Thanks,

--
Javier Lopez
Software Engineer
cozybit Inc.
