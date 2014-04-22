Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53887 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbaDVSG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 14:06:28 -0400
Received: by mail-lb0-f174.google.com with SMTP id u14so4604405lbd.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 11:06:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U5=rt+VS4dhrLb-oLun_fw2qSbEQhLYdFnAhUYep791g@mail.gmail.com>
References: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com>
 <1398180129.4211.22.camel@jlt4.sipsolutions.net> <CAB=NE6U5=rt+VS4dhrLb-oLun_fw2qSbEQhLYdFnAhUYep791g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 11:06:07 -0700
Message-ID: <CAB=NE6XVyRaEmGh8xPj20FCU460-LY236ScakwxG9jK9=JkWBg@mail.gmail.com> (sfid-20140422_200633_159740_F7D55B81)
Subject: Re: [PATCH] cfg80211: reg: track crda request
To: Johannes Berg <johannes@sipsolutions.net>,
	Sander Eikelenboom <linux@eikelenboom.it>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 10:24 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> I'll work on this and send out something
> shortly.

Actually just posted my review of the patch. If we address this I
think it can go in but I'd like it split up as much as possible -- as
is right now we don't set a limit for the recurring timeout. That
should be addressed.

  Luis
