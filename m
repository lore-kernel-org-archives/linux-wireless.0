Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:20840 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXKNQpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:45:07 -0500
Received: by nf-out-0910.google.com with SMTP id g13so210688nfb
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 08:45:05 -0800 (PST)
Message-ID: <c85cb4470711140845m138df42pbbd15f7f666d74ef@mail.gmail.com> (sfid-20071114_164626_270867_04BDCBD6)
Date: Wed, 14 Nov 2007 18:45:04 +0200
From: "Ron Rindzonski" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 02/15] mac80211: adding 802.11n definitions in ieee80211.h
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195056268.4091.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <11950542003481-git-send-email-ron.rindjunsky@intel.com>
	 <1195056268.4091.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This patch adds several structs and definitions to ieee80211.h
> > to support 802.11n draft specifications.
> > As 802.11n depends on and extends the 802.11e standard in several issues,
> > there are also several definitions that belong to 802.11e.
>
> Do I remember wrongly or didn't you want to add comments here to explain
> the structure names?
>

correct, i will add them and resend this patch
thanks

> Thanks,
> Johannes
>
>
