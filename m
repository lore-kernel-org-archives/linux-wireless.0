Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36510 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbbELHx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 03:53:58 -0400
Received: by iecmd7 with SMTP id md7so1693118iec.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 00:53:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGm1_ktjoyQp_sebmPrG__4kgmW-EnR16tv6rd2sPECD8uFrtQ@mail.gmail.com>
References: <CAGm1_ktjoyQp_sebmPrG__4kgmW-EnR16tv6rd2sPECD8uFrtQ@mail.gmail.com>
Date: Tue, 12 May 2015 10:53:57 +0300
Message-ID: <CAB3XZEd6GbsQfs7EZxvrea7hxJjbqnVuHO5pQc3gZCmG-0V8sw@mail.gmail.com> (sfid-20150512_095401_398912_2FE04918)
Subject: Re: wlcore: mac-address property support
From: Eliad Peller <eliad@wizery.com>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Tue, May 12, 2015 at 9:37 AM, Yegor Yefremov
<yegorslists@googlemail.com> wrote:
> Does wlcore support "mac-address" property, so that MAC address could
> be set via Device Tree?
>
it's currently not supported.
(by default the address is read from the fuse ROM, and it can be
overridden by the nvs file)

Eliad.
