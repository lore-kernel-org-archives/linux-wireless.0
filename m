Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:45614 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbYFHQLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 12:11:50 -0400
Received: by an-out-0708.google.com with SMTP id d40so422644and.103
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 09:11:49 -0700 (PDT)
Message-ID: <43e72e890806080911v4aba1079t438b8ac2265d4194@mail.gmail.com> (sfid-20080608_181154_384888_DB13B632)
Date: Sun, 8 Jun 2008 09:11:49 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Mark S." <throaway@yahoo.com>
Subject: Re: Problem with 2.6.22 / Unknown symbol netif_subqueue_stopped
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200806012217.22151.throaway@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200806012217.22151.throaway@yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 1, 2008 at 10:17 PM, Mark S. <throaway@yahoo.com> wrote:
> Hello!
>
> I'm running kernel 2.6.22. I've compiled and installed the wireless drivers
> from your latest tarball, which the documentation says should work with
> 2.6.22.  I'm using the kernel source for KLIB_BUILD. When attempting to load
> the resulting module zd1211rw, there is a cascade of errors starting with
>
>  mac80211:  Unknown symbol netif_subqueue_stopped

This required MQ backport which I just finished an attempt for, please
give it a try and let me know how it goes.

  Luis
