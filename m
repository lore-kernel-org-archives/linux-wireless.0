Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:40240 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932418AbcBAO2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 09:28:25 -0500
Message-ID: <1454336901.7329.63.camel@perches.com> (sfid-20160201_152828_965854_DA46CB09)
Subject: Re: [PATCH 3/3] Staging: rtl8723au: core: rtw_ieee80211: Fixed
 space and brace coding style issue.
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rakhi Sharma <rakhish1994@gmail.com>, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Date: Mon, 01 Feb 2016 06:28:21 -0800
In-Reply-To: <wrfjio287gwy.fsf@redhat.com>
References: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com>
	 <wrfjy4b5zuhl.fsf@redhat.com> <1454261145.7329.58.camel@perches.com>
	 <wrfjio287gwy.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 07:29 -0500, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
[]
> > so this could be transformed into something like:
> > 
> > int rtw_get_bit_value_from_ieee_value23a(u8 val)
> > {
> > 	int i;
> > 	static const u8 dot11_rate_table[] = {
> > 		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
> > 	};
> 
> and per my previous email, the above is worse than than the original.
> The cleaner way to list it would be:
> 
> 	static const char dot11_rate_table[] =
> 		{ 2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108 };

Either style is OK, but the style I used is slightly
more common in the kernel overall, about 2:1.

The type should ideally be u8 and not char.

