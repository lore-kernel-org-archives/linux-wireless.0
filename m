Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3AXPiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:38:19 -0500
Date: Thu, 24 Jan 2013 16:38:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arun Koshal <akoshal@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Need help on Intel 3945ABG problem with Linux Mint 13
Message-ID: <20130124153815.GA3284@redhat.com> (sfid-20130124_163822_393847_864EC684)
References: <1358665969.52744.YahooMailNeo@web120006.mail.ne1.yahoo.com>
 <1358667286.45583.YahooMailNeo@web120002.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358667286.45583.YahooMailNeo@web120002.mail.ne1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 19, 2013 at 11:34:46PM -0800, Arun Koshal wrote:
> Linux laptop 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:41:14 UTC 2012 i686 i686 i386 GNU/Linux
<snip>
> 
> WiFi connectivity with the access point works fine if the distance between the laptop and the access point is 1 or 2 feets. But it does not work if the distance is more than that. I get following messages in the /var/log/syslog file when the problem occurs -

You are using quite old kernel, try new one i.e. 3.7.x . If problem
still happens there, try some old kernel - the best whould be 2.6.38 .

If neigher new nor old kernel do not work, I'll rather suspect hardware
problem, i.e. pure anthenna or anthenna not correctly connected to
device.

Stanislaw

