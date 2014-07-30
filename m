Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39546 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbaG3Rq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 13:46:27 -0400
Received: by mail-ie0-f173.google.com with SMTP id tr6so1994241ieb.18
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2014 10:46:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D92B47.3000305@broadcom.com>
References: <BLU180-W14370D921EDB121FE8EC149DF90@phx.gbl>
	<BLU180-W146AAC9DB0BDA5C16DED8B9DF90@phx.gbl>
	<53D90FCA.9030603@broadcom.com>
	<BLU180-W3796F15428964196877C529DF90@phx.gbl>
	<53D92B47.3000305@broadcom.com>
Date: Wed, 30 Jul 2014 19:46:26 +0200
Message-ID: <CACna6ryTzEY2yzjRp4hd86af3HRVeRO+kG=xM+xgDbjaAP71Fw@mail.gmail.com> (sfid-20140730_194631_415189_DEBE4D26)
Subject: Re: Bug Driver Broadcom
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?B?QU5EUsOJIFNJ?= <andre_cte2010@hotmail.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 July 2014 19:28, Arend van Spriel <arend@broadcom.com> wrote:
> Looking at the kernel long I see you are using the hybrid wl driver. This
> driver is not what we (brcm80211-dev-list) are supporting. Despite that and
> the surprising fact that Brazil is part of the EU, it seems channels 12 and
> 13 are enabled.

Guys (Andre), it's a bit annoying you dropping mailinglist from the
recipients. Keep the discussion on the list.

Arend: what wl.ko reports using cfg80211 is one thing, what it does
internally is another. I often got it reporting support for channels
12 and 13, but it wasn't scanning on them.
