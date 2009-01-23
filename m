Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41243 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbZAWCMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 21:12:01 -0500
Date: Thu, 22 Jan 2009 21:14:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression caused by commit
	e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
Message-ID: <20090123021413.GB3177@tuxdriver.com> (sfid-20090123_031206_765431_F2F627EE)
References: <4979269F.1060500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4979269F.1060500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 08:08:31PM -0600, Larry Finger wrote:
> With the commit of the subject, my b43 and p54usb devices stopped working. They could
> associate and authenticate with my WPA2 network, but never finish the DHCP connection and
> get an IP address. Surprisingly, my rtl8187 devices continued to work.
> 
> Please excuse the second sending of this. I missed wireless the first time.

I reverted this in wireless-testing (and it never went anywhere
upstream).  Of course, now it looks like Samuel has a fix...maybe
I'll combine them...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
