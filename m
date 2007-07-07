Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp146.iad.emailsrvr.com ([207.97.245.146]:48542 "EHLO
	smtp146.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbXGGRZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 13:25:54 -0400
Message-ID: <468FCC4A.2010102@gentoo.org>
Date: Sat, 07 Jul 2007 13:24:26 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Errors when firmware is missing
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com> <1183826476.3779.42.camel@johannes.berg>
In-Reply-To: <1183826476.3779.42.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> that for zd1211
> no device is created is probably counter-productive, that way userspace
> will never know that a wireless adapter is plugged in.

This is fixed for zd1211rw in my latest bunch of patches. But it 
certainly wouldn't surprise me if future hardware/drivers are not able 
to create an interface before loading firmware.

It implies that you have a way of reading the MAC address before 
uploading firmware. I only figured this out for zd1211 by reverse 
engineering the boot code to an extent.

Daniel
