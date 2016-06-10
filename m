Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35005 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbcFJU3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 16:29:01 -0400
Received: by mail-wm0-f42.google.com with SMTP id v199so6296209wmv.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 13:29:00 -0700 (PDT)
Subject: Re: NL80211_ATTR_PAD question
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <575B1964.2030806@candelatech.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <575B230A.3070208@broadcom.com> (sfid-20160610_222905_493367_69BA6082)
Date: Fri, 10 Jun 2016 22:28:58 +0200
MIME-Version: 1.0
In-Reply-To: <575B1964.2030806@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10-06-16 21:47, Ben Greear wrote:
> I see this was added sometime recently:  NL80211_ATTR_PAD
> 
> If another enum member is added, should it replace the PAD enum?

Nope. This attribute is used as padattr by 64-bit aligned netlink
functions, ie. nla_put_u64_64bit().

> At the least, I think we need some comments about how this is to be dealt
> with.

> * @NL80211_ATTR_PAD: attribute used for padding for 64-bit alignment

This could indeed use a bit more explanation.

Regards,
Arend
