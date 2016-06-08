Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423933AbcFHMV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 08:21:56 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>,
	driverdev-devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] *** r8723au: Replace semaphore lock with mutex ***
References: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
Date: Wed, 08 Jun 2016 08:21:54 -0400
In-Reply-To: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org> (Binoy
	Jayan's message of "Wed, 8 Jun 2016 13:10:53 +0530")
Message-ID: <wrfjy46fx44d.fsf@redhat.com> (sfid-20160608_142218_101990_20AFF996)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Binoy Jayan <binoy.jayan@linaro.org> writes:
> Hi,
>
> These are a set of patches which removes semaphores from:
>
> drivers/staging/rtl8723au
>
> These are part of a bigger effort to eliminate all semaphores 
> from the linux kernel.
>
> They build correctly (individually and as a whole).
> NB: I have not tested this as I do not have the following hardware:
>
> R8723AU
> "Realtek RTL8723AU Wireless LAN NIC driver"

I am not against this, but please note this driver is already marked for
deletion in a future kernel release.

Cheers,
Jes
