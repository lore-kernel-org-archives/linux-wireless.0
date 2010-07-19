Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57695 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966729Ab0GSVAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 17:00:14 -0400
Date: Mon, 19 Jul 2010 16:48:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pauli Nieminen <suokkos@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8180L is hitting WARN_ON in net/wireless/scan.c:575
Message-ID: <20100719204806.GB6115@tuxdriver.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 17, 2010 at 10:30:49AM +0300, Pauli Nieminen wrote:
> Hi,
> 
> I'm testing 2.6.35-rc4+, I have problem that warning is spamming dmesg
> when I have my wifi on. Actual problem caused y that problem is that I
> can't scan/connect to any network with 2.6.35.
> 
> When I looked the code in warning it might be related to problem that
> my wifi reports all signal strength to be 175 or 178 (if I remember
> correctly). I'm now using 2.6.35 so I can't check the reported values
> from scan results.

I just sent "rtl8180: improve signal reporting for rtl8185 hardware"
as a reply to this email.  Can you try that patch?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
