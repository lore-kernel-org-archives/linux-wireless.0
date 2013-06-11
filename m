Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33769 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab3FKTRV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:17:21 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] carl9170: make use of the new rate control API
From: =?windows-1252?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <201306111946.22682.chunkeey@googlemail.com>
Date: Tue, 11 Jun 2013 21:17:19 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name, johannes@sipsolutions.net
Message-Id: <1E3747D2-BD9C-4136-B17F-9227E24136D5@net.t-labs.tu-berlin.de> (sfid-20130611_211723_764786_A52570A5)
References: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <201306111946.22682.chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

I have not seen that patch in wireless-next, that's why I overlooked it… sorry.

> 
> ???
> 
> carl9170 already supports the new rate control API (Patch from 2013-04-23).
> <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/107657>
> 
> Can you please tell me what you think is missing?
> 

You patch looks good to me.
As I just saw an ath9k patch for rcu protection when ieee80211_get_tx_rates() is called.
Should this be done in carl9170 as well ?

Greetinsg,
Thomas

> Regards,
> 	Chr
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

