Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2AJSuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 13:50:07 -0500
Message-ID: <1326221418.5067.5.camel@dcbw.foobar.com> (sfid-20120110_195012_044672_1727BE42)
Subject: Re: compat-wireless + libertas + firmware issue
From: Dan Williams <dcbw@redhat.com>
To: Eduardo Silva <edsiper@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jan 2012 12:50:18 -0600
In-Reply-To: <CAMAQhePeKnnfQrZHcLcvo=RyuNsp0NgV96PdCyaLxT-X3iWj2A@mail.gmail.com>
References: <CAMAQhePeKnnfQrZHcLcvo=RyuNsp0NgV96PdCyaLxT-X3iWj2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-09 at 10:17 -0300, Eduardo Silva wrote:
> Hi,
> 
> i have a device with Marvell chip running Kernel 2.6.28. I am looking
> to use the updated libertas_sdio driver from compat-wireless. I have
> added compat-wireless 2.6.39.1 to the system image and dropped the old
> drivers. When using the new libertas_sdio, it cannot find the
> firmware:
> 
>        libertas: failed to find firmware (-2)
> 
> If i build a new system image with the original 2.6.28 libertas
> drivers the firmware is located and loaded properly. I also tried
> different firmware versions and all have the same behavior. Is there
> any difference about how compat-wireless look for specific firmwares
> ?, i also tried the  CONFIG_FIRMWARE_IN_KERNEL and the issue persist.
> 
> any help is appreciated,

FYI he fixed this...  compat-wireless requires slightly different udev
firmware helper rules.

Dan

