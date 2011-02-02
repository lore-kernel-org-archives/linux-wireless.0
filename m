Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46582 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBHv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 02:51:59 -0500
Received: by qyk12 with SMTP id 12so8475733qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 23:51:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D490746.9070207@zebulon.org.uk>
References: <4D490746.9070207@zebulon.org.uk>
Date: Wed, 2 Feb 2011 07:51:58 +0000
Message-ID: <AANLkTimt-j-CkHB9GTRpqhgjEnhSrHL0hcNZW5BMhMrN@mail.gmail.com>
Subject: Re: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
From: Eric Fernandez <zeb@zebulon.org.uk>
To: Johannes Stezenbach <js@sig21.net>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> proprietary modules :-(
>

This is probably nvidia.

> Can you double check rfkill module is from compat-wireless
> and not from you kernel?

You may be right, I cannot find rfkill in /updates. It should be
compiled with the compat-wireless building?

Actually this problem starts to be reported by others, with other
adapters. I'll try to see what is going on with Arch devs.

Anyway, I still have the original issue of unstability and crashes
(and this is reported too for several distributions that distribute
2.6.37).

Many thanks !
Eric
