Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:8454 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbZFKAVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 20:21:21 -0400
Received: by an-out-0708.google.com with SMTP id d40so1999025and.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 17:21:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244664108-3997-3-git-send-email-hauke@hauke-m.de>
References: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
	<1244664108-3997-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Jun 2009 17:21:02 -0700
Message-ID: <43e72e890906101721i3e45b9fev40892e6babe5fc6e@mail.gmail.com>
Subject: Re: [PATCH 3/3] [compat-2.6] Backport rfkill for kernel older than
	2.6.31.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, julian.calaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 1:01 PM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

Thank you!!!!! New tarball generated with all the latest updates and yours.

wireless-testing latest tag:
master-2009-06-10
This is compat-release:
master-2009-06-10

I'll just note that we won't be able to catch the NETDEV_PRE_UP netdev
notifier event. We use this in cfg80211 to disallow users from
bringing the interface up when we know the device is rfkilled. Doesn't
seem so bad.

  Luis
