Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40246 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3EIPgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 11:36:50 -0400
Message-ID: <518BC290.2040306@lwfinger.net> (sfid-20130509_173720_224963_3CDA7434)
Date: Thu, 09 May 2013 10:36:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	hostap@lists.shmoo.com
Subject: Re: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken
 at times
References: <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
In-Reply-To: <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2013 06:56 AM, Norbert Preining wrote:

> in the current state, that is release 3.9.0, but the same happened
> in earlier kernels, this driver and/or NM is completely useless
> at times. At times it just works, at times it does nothing.
> In this case, now the 5th day in series ...

Nice long rant. Too bad we don't have a soapbox.

With all the information you provided, you forgot one detail that is absolutely 
critical, namely the PCI ID. There are at least three varieties of RTL8191SE 
chip, and I have no idea which one you have.

I also recommend that you try either the wireless-testing git repo or the 
mainline git repo. There are a lot of changes that cannot be backported.

Larry



