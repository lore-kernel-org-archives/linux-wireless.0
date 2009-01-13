Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:52803 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607AbZAMKlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 05:41:40 -0500
Received: by mu-out-0910.google.com with SMTP id g7so4480954muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 02:41:38 -0800 (PST)
Message-ID: <b25312890901130241l635ffe78na10d2aa468365e7e@mail.gmail.com> (sfid-20090113_114153_530368_1DA396AB)
Date: Tue, 13 Jan 2009 12:41:38 +0200
From: "Rami Rosen" <roszenrami@gmail.com>
To: "Jason Newton" <nevion@gmail.com>
Subject: Re: 802.11n status (iwlagn)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <496C3F37.4030808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <496C3F37.4030808@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
>  what the current status of 802.11n is in linux as a whole

In http://www.linuxwireless.org/en/users/Drivers, there
is a table of drivers; some of them do support 802.11n,
as you can see form the PHY modes column
(there might be more such drivers, take into account that this table
might not be always up to date).

 Intel iwl4965 is among them;  I did not perform any tests with
4965-based iwlagn devices with 80211.n though.

- I believe that you are aware that the 80211.n spec is expected
only at the end of 2009 (December 2009) or later.

Rgs,
Rami Rosen




On Tue, Jan 13, 2009 at 9:13 AM, Jason Newton <nevion@gmail.com> wrote:
> Hi all,
>
> I've been searching around for a long time now and I find it difficult
> to understand what the current status of 802.11n is in linux as a whole
> and what it is with respect to iwlagn (4965 chipset specifically).  I
> want high-speed and reliable wireless :-)
>
> Also, it would seem iwlagn n/ht still isn't working in 2.6.28?
>
> To anyone who can clear all this up for me, I'd be much appreciative.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
