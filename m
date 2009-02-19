Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:61247 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZBSVpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 16:45:52 -0500
Received: by gxk22 with SMTP id 22so1734616gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 13:45:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499DA503.4070404@hauke-m.de>
References: <499DA503.4070404@hauke-m.de>
Date: Thu, 19 Feb 2009 13:45:50 -0800
Message-ID: <43e72e890902191345r74688e72hb9181aa1e4ae25aa@mail.gmail.com> (sfid-20090219_224556_828023_B7D7EE90)
Subject: Re: [PATCH] compat-2.6: compat.diff update for master-2009-02-18
	wireless-testing.
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2009 at 10:29 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Hi Luis,
>
> this patch makes compat-wireless work with the latest wireless-testing
> again.
> It also adds the at76c50x-usb driver.
> I tested b43 with kernel 2.6.27 and rtl8187 with kernel 2.6.29-rc5.

Thanks! Applied with some small changes (leave iwlwifi kconfig changes
in a separate patch).

compat-wireless updated and new tarball regenerated.

  Luis
