Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3209 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZLWRaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 12:30:05 -0500
Subject: Re: modprobe fail and subsequent crash on rmmod ath9k D-Link DWA
 652
From: Pavel Roskin <proski@gnu.org>
To: Russ Adams <russ.adams@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <bfff2faa0912230911w15966e9sbfbba9bd303d3314@mail.gmail.com>
References: <bfff2faa0912190727jc7fa067gf46425d1cd443698@mail.gmail.com>
	 <bfff2faa0912230911w15966e9sbfbba9bd303d3314@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 23 Dec 2009 12:30:00 -0500
Message-Id: <1261589400.7538.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-23 at 12:11 -0500, Russ Adams wrote:
> Nothing new on this just yet.
> 
> Tonight I will try 2.6.32-2 to see if that fixes the problem.  Does
> anyone have any debugging steps I can try?

Remember, I asked you to show the debug messages after the ath9k module
is loaded.  If it's loaded on startup, you can blacklist it and then
load manually with modprobe.

It seems to me that something fails during the initialization, which
causes a crash at the unload time.  But since ath9k is working properly
for most of us, it's hard to figure out what is failing and how to model
the problem on functioning hardware.

-- 
Regards,
Pavel Roskin
