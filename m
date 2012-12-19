Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50375 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LSSp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 13:45:59 -0500
Received: by mail-ee0-f53.google.com with SMTP id c50so1225062eek.12
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 10:45:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355782661-19059-2-git-send-email-juhosg@openwrt.org>
References: <1355782661-19059-1-git-send-email-juhosg@openwrt.org> <1355782661-19059-2-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 19 Dec 2012 10:38:48 -0800
Message-ID: <CAB=NE6U7KBp-WChXX=hm9oGV5z3v9qFP-J7u89xMhhb=ThUkGw@mail.gmail.com> (sfid-20121219_194604_497678_FE78EEBA)
Subject: Re: [PATCH 2/2] qca-swiss-army-knife: print ar9280PciePhy_awow array
To: Gabor Juhos <juhosg@openwrt.org>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2012 at 2:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> This array has been introduced by commit
> 3b604b6cf811ba14e4c2bb3005e29bb2fba77af0
> (ath9k_hw: INI changes for WoW for AR9002
> chipsets) in linux, but it is not printed
> from initvals.
>
> Add it, and update ar9002_initvals.h and
> checksums.txt.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Applied and pushed both patches, thanks!

  Luis
