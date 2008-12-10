Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYLJOaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 09:30:13 -0500
Date: Wed, 10 Dec 2008 09:22:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: siamer <siamer@interia.pl>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: b43 phy0 error
Message-ID: <20081210142257.GB5168@tuxdriver.com> (sfid-20081210_153019_345578_82392EB8)
References: <20081210003948.24694199B271@f14.poczta.interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081210003948.24694199B271@f14.poczta.interia.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 01:39:47AM +0100, siamer wrote:
> Hi i have broadcom 4318 wireless card (laptop asus a6km) when i'm
> using firmware from linuxwiereless.com (4.150.10.5) then internet is
> working but when i'm starting download something than is disconnecting
> me. dmesg show : b43 phy0 error
> I tryed that on few different distros and on different kernels
> (2.6.25 2.6.26 2.6.27 wireless-testing and compact-wireless) is the
> same... PLEASE HELP ME... Why is like that ?

This is one of the nagging mysteries of the BCM43xx hardware -- we
don't know what causes it.  Can you reliably recreate the problem?
If so, perhaps you can use wireshark with another wireless device in
monitor mode to capture a trace of what is happening?

John

P.S.  You probably should be sending stuff to
linux-wireless@vger.kernel.org instead.
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
