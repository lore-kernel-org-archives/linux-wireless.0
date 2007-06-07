Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.polimi.it ([131.175.12.3]:45222 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933584AbXFGT1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 15:27:25 -0400
From: stefano.brivio@polimi.it
Message-ID: <20070607212718.c9chfckmosg4w0wk@webmail.polimi.it>
Date: Thu, 07 Jun 2007 21:27:18 +0200
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: Regulatory info in mac80211
References: <4665CCE7.5090409@lwfinger.net> <20070607091040.2b2f1d00@morte>
	<43e72e890706071152n2d687497va9449d330e2078b4@mail.gmail.com>
In-Reply-To: <43e72e890706071152n2d687497va9449d330e2078b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> A bigger issue for users is support. As you very well know reverse
> engineering is a long tedious process; we are essentially doomed to
> reverse engineering  wireless drivers for some wireless devices where
> regulatory compliance sits in the driver due to vendor fears on legal
> liability. I'm not saying their fears are justified by any means I'm
> just saying those fears do exist by some vendors and unfortunately we
> suffer the consequences. So if we can do some sort of best effort,
> perhaps we can steer some vendors to support us.

I would say that we should do our best in supporting users instead.

Furthermore, I understand your concerns, but:
1) I think that a weak regulatory domain support (such as commented  
defines in the mac80211 code) is sufficient to claim we comply with  
regulatory domains, while avoiding to hassle users.
2) We won't get any vendor to support us thanks to regulatory  
compliance. There are just some weird vendors such as Broadcom and  
some friendly vendors such as Realtek: it's unrealistic that vendors  
such as Broadcom would ever change their mind. You may say my point is  
short-sighted, but I really can't think that we can steer a vendor to  
support us just by complying to regulatory domains: it looks clear to  
me that Broadcom and other weird vendors such as TI are just  
ridicolously trying to protect IP. Or are you talking about the  
almost-friendly vendors like Intel?
3) The GPL license, in my humble opinion, aims at the most possible  
freedom. I don't care if vendors support us if we don't aim at this.

However, as you can see, I CC'ed Theo DeRaadt, who, being an expert  
about these issues, will sure provide us with the best advice about  
what to do.


--
Ciao
Stefano



