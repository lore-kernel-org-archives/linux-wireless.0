Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33648 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2BMNyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 08:54:31 -0500
Received: by pbcun15 with SMTP id un15so4565823pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 05:54:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120210012321.CA97C17F947@vari.ath.cx>
References: <20120210012321.CA97C17F947@vari.ath.cx>
Date: Mon, 13 Feb 2012 14:54:30 +0100
Message-ID: <CAGXE3d8096hu2Gm+5VzSJca9GHaUqFKDR6L8fFBr-VmYdJmbuw@mail.gmail.com> (sfid-20120213_145434_383490_7FADFFCD)
Subject: Re: phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free
 entry in the non-full queue 2.
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Mj <madis@cyber.ee>
Cc: IvDoorn@gmail.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 2:23 AM, Mj <madis@cyber.ee> wrote:
> phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
>
> I get this error fairly regularly (about once per day or two) and
> the wireless stops working after that. Work-around is suspending
> the laptop (EeePC 1000) and waking it again - after that
> the rt2800pci driver seems to get into working state again.

Mind to compile rt2x00 with debugfs support and check the queue length
in /sys/kernel/debug/ieee80211/netdev:wlan0/rt2800pci/queues when this
issue appears?

Thanks,
Helmut
