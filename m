Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64500 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AXMqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 07:46:08 -0500
Received: by iwn9 with SMTP id 9so3934534iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 04:46:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D3B0390.5070108@broadcom.com>
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com> <4D3B0390.5070108@broadcom.com>
From: Jamie Kitson <jamie@kitten-x.com>
Date: Mon, 24 Jan 2011 12:45:47 +0000
Message-ID: <AANLkTinwPrar6ZBhSALBif8__4mHHsKuDYKsgr4FDqtu@mail.gmail.com>
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Rereading the whole thread I noticed the PREEMPT in your uname message. Does
> this mean you are running with CONFIG_PREEMPT (Preemptible Kernel)?

Apparently so. I'm using the stock Arch kernel.

> This may not be supported by this driver.

Ok, how would I find out for sure?
