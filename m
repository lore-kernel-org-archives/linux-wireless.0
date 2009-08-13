Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:37263 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZHMU4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:56:37 -0400
Received: by pxi34 with SMTP id 34so114735pxi.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 13:56:38 -0700 (PDT)
Message-ID: <4A847CC1.6060308@lwfinger.net>
Date: Thu, 13 Aug 2009 15:51:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Spare warnings - wireless drivers
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
In-Reply-To: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> b43:
> 
>   CHECK   drivers/net/wireless/b43/phy_g.c
> drivers/net/wireless/b43/phy_g.c:974:56: warning: cast truncates bits
> from constant value (ffff7fff becomes 7fff)
> 
> ...
> 
>   CHECK   drivers/net/wireless/b43/wa.c
> drivers/net/wireless/b43/wa.c:385:60: warning: cast truncates bits
> from constant value (ffff00ff becomes ff)
> drivers/net/wireless/b43/wa.c:403:55: warning: cast truncates bits
> from constant value (ffff00ff becomes ff)
> drivers/net/wireless/b43/wa.c:405:55: warning: cast truncates bits
> from constant value (ffff00ff becomes ff)
> drivers/net/wireless/b43/wa.c:415:71: warning: cast truncates bits
> from constant value (ffff0fff becomes fff)

I'm aware of these warnings, and I have fixes for all of them. I'm
waiting for the new LP PHY to get checked in as there are a number in
it as well.

Larry

