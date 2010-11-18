Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61723 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab0KRNqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 08:46:07 -0500
Received: by qwd7 with SMTP id 7so115865qwd.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 05:46:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
References: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
Date: Thu, 18 Nov 2010 08:46:04 -0500
Message-ID: <AANLkTinLBBMapuktN1rqNEJjYb1P-fP833wmgoybJ4Xb@mail.gmail.com>
Subject: Re: module unloading busted ?
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 2:26 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> 05:33 < mcgrof> so module unload on ath9k no longer works
> 06:11 < vmraj> mcgrof: module unload is not working for intel cards too
> 06:15 < vmraj> it can be reproduced by rmmod on active connection
>
> I haven't yet figured out why. Anyone else with other modules experiencing this?

I guess this explains the ath5k one from another thread too.

-- 
Bob Copeland %% www.bobcopeland.com
