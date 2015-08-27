Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbbH0NNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 09:13:02 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging/rtl8723au: Use %pM format specifier to print mac address
References: <1440680785-9327-1-git-send-email-kuleshovmail@gmail.com>
	<1440680967-9514-1-git-send-email-kuleshovmail@gmail.com>
Date: Thu, 27 Aug 2015 09:13:01 -0400
In-Reply-To: <1440680967-9514-1-git-send-email-kuleshovmail@gmail.com>
	(Alexander Kuleshov's message of "Thu, 27 Aug 2015 19:09:27 +0600")
Message-ID: <wrfj8u8wvpr6.fsf@redhat.com> (sfid-20150827_151307_264962_3290B06B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexander Kuleshov <kuleshovmail@gmail.com> writes:
> printk() supports %pM format specifier for printing 6-byte MAC/FDDI
> addresses in hex notation small buffers, let's use it intead of %x:%x...
>
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Works for me

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
