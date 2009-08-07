Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:54123 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbZHGLYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 07:24:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: ath5k - strange regulatory domain change
Date: Fri, 7 Aug 2009 13:24:44 +0200
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com>
In-reply-To: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200908071324.45269.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chris Clayton wrote:
> Because of some problems with my Belkin Wireless G card  (model
> F5D7010) and the rt61pci driver, I've started to use a "no-name" card
> that is supported by the ath5k driver.
> 
> A problem is that I have come across is that for some reason the CN
> regulatory domain is being set automatically. This doesn't happen with
> the Belkin (rt61) card. I have the following line in
> /etc/modprobe.d/modprobe.conf to set the regulatory domain to GB:
> 
> options cfg80211 ieee80211_regdom=GB

This issue has already been discussed extensively (after I reported it). 
Please see the following thread: http://lkml.org/lkml/2009/7/8/421. It 
contains a lot of information from the wireless maintainers.

Cheers.
FJP
