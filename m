Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:32990 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0K3TIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:15 -0500
Message-ID: <4CF54B97.40604@hauke-m.de>
Date: Tue, 30 Nov 2010 20:08:07 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: thomas@xyz.pp.se
CC: linux-wireless@vger.kernel.org
Subject: Re: wireless.kernel.org update
References: <1291106122.13696.0.camel@thonov-ubuntu>
In-Reply-To: <1291106122.13696.0.camel@thonov-ubuntu>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2010 09:35 AM, Thomas Novin wrote:
> Hello
> 
> This page,
> http://wireless.kernel.org/en/users/Download#Getting_compat-wireless_on_Ubuntu, should be updated to include Maverick/10.10.
> 
> If I just try to install as instructed for other versions:
> 
> sudo apt-get install linux-backports-modules-wireless-lucid-generic
> 
> I get:
> 
> E: Unable to locate package
> linux-backports-modules-wireless-lucid-generic

I added the package names for Ubuntu 10.10 into the wiki. The Ubuntu
guys changed the name of the package but the meta package is still
depending on the old names, this is a Ubuntu bug. (see:
https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/681727 )

Hauke
