Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:53542 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbXFCKdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 06:33:38 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1378306mue
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2007 03:33:36 -0700 (PDT)
Message-ID: <7b4bf7ff0706030333j21152541hed9384e965cacaa9@mail.gmail.com>
Date: Sun, 3 Jun 2007 12:33:36 +0200
From: "Olivier Cornu" <o.cornu@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate in rc80211_simple
Cc: "Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/6/2, Larry Finger <Larry.Finger@lwfinger.net>:
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. This is too fast for the bcm43xx-mac80211
> driver. To correct this situation without affecting any other driver,
> an initial_rate parameter is added to the rc80211_simple module.

What if two different mac80211 device drivers need two different initial rates?

--
Olivier Cornu
