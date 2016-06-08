Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:63967 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161549AbcFHPhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	driverdev-devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] *** r8723au: Replace semaphore lock with mutex ***
Date: Wed, 08 Jun 2016 17:38:25 +0200
Message-ID: <4241695.VyWSyJFnNN@wuerfel> (sfid-20160608_173806_035020_40496F4B)
In-Reply-To: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
References: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, June 8, 2016 1:10:53 PM CEST Binoy Jayan wrote:
> These are a set of patches which removes semaphores from:
> 
> drivers/staging/rtl8723au
> 
> These are part of a bigger effort to eliminate all semaphores 
> from the linux kernel.
> 
> They build correctly (individually and as a whole).

Looks good,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
