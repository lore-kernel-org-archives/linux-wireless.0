Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46866 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FYAzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 20:55:17 -0400
Received: by mail-ie0-f174.google.com with SMTP id 9so26084201iec.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 17:55:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C52E79.30104@rempel-privat.de>
References: <51C52E79.30104@rempel-privat.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 24 Jun 2013 17:54:56 -0700
Message-ID: <CAG6hwVOCfDK9nkh3e0fFMGcWp8XLQnPC8TzQb9eET2fwFPq3SA@mail.gmail.com> (sfid-20130625_025535_552544_1C117232)
Subject: Re: regression after, " ath9k_htc: Add support for mesh interfaces"
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 21, 2013 at 9:56 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Hi Javier,
>
> i warning after patch "ath9k_htc: Add support for mesh interfaces".
> I get this warning only on pc with CONFIG_MAC80211_MESH not set. Probably
> you missed config check some where.

Where do you hit the warning?

--
Thomas
