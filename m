Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:51380 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0I0PGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 11:06:06 -0400
Subject: Re: active vs. passive scans
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Chuck Crisler <ccrisler@vgocom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <15713CDD627C41D39E4B9725AE2B241D@ChuckPC>
References: <15713CDD627C41D39E4B9725AE2B241D@ChuckPC>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 18:06:04 +0300
Message-ID: <1285599964.5768.120.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chuck,

On Mon, 2010-09-27 at 16:03 +0200, ext Chuck Crisler wrote:
> How to you get the supplicant/linux wireless to perform active scans rather 
> than passive scans? Are active scans faster?

We do active scans by default, unless specified otherwise in the
regulatory database.

The main difference between active and passive scans is that in active
scans we send broadcast probe requests on the channel and with passive
we don't.  In passive scan we just listen to beacons.

Usually the drivers stay for a certain period of time in each channel,
and that normally doesn't change if you have active or passive scan.  So
there will be no improvement in the overall scan speed.  Of course you
could do some tweaks that might improve scanning performance in specific
cases.


-- 
Cheers,
Luca.

