Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbcAEPyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 10:54:03 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: meleodr@gmail.com
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: rtl8723au: use %pM and %ph formatting
References: <1451565407-15039-1-git-send-email-meleodr@gmail.com>
Date: Tue, 05 Jan 2016 10:54:02 -0500
In-Reply-To: <1451565407-15039-1-git-send-email-meleodr@gmail.com>
	(meleodr@gmail.com's message of "Thu, 31 Dec 2015 15:36:42 +0300")
Message-ID: <wrfj1t9wqaxx.fsf@redhat.com> (sfid-20160105_165422_489898_F8C81C15)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

meleodr@gmail.com writes:
> From: Daniil Leshchev <meleodr@gmail.com>
>
> use %pM and %ph specifiers instead of placing each byte on stack.
> (staging/rtl8723au/TODO)
>
> Signed-off-by: Daniil Leshchev <meleodr@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_recv.c          | 32 +++++-----------------
>  .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    | 24 ++++------------
>  drivers/staging/rtl8723au/hal/usb_halinit.c        |  6 ++--
>  3 files changed, 15 insertions(+), 47 deletions(-)

Looks fine to me.

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
