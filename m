Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58434 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab3BKNBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 08:01:40 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so2736405eaa.37
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 05:01:39 -0800 (PST)
Message-ID: <5118EBAF.7070307@gmail.com> (sfid-20130211_140144_701541_F08D7E59)
Date: Mon, 11 Feb 2013 14:01:35 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: marlon.smith10@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Compile for ARM
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marlon Smith wrote:

> I'm having some problems with the Ralink supplied driver for my RT3070
> USB dongle, so I'd like to try using your driver instead.  I downloaded
> compat-wireless-2012-12-18 and I would like to compile it for ARM.
> Running ./scripts/driver-select rt2x00 complains about i686 stuff (which
> it should), and I figure I need to set some configuration option to
> compile for ARM instead.
> 
> Can anyone point me in the right direction for this?

try it with latest stable: http://www.kernel.org/pub/linux/kernel/projects/backports/stable/
or -next: http://www.kernel.org/pub/linux/kernel/projects/backports/2013/
