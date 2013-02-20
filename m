Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51698 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3BTU1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:27:52 -0500
Received: by mail-ie0-f182.google.com with SMTP id k14so10381134iea.41
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 12:27:52 -0800 (PST)
Date: Wed, 20 Feb 2013 15:27:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: devel@lists.open80211s.org, Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
Message-ID: <20130220202736.GD21725@localhost> (sfid-20130220_212758_474549_0B773C61)
References: <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
 <20771.50338.434076.484711@gargle.gargle.HOWL>
 <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
 <20771.51233.248133.141840@gargle.gargle.HOWL>
 <alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
 <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
 <alpine.DEB.2.02.1302200027120.19533@icf.org.ru>
 <20130220142401.GA21725@localhost>
 <alpine.DEB.2.02.1302202351280.2057@icf.org.ru>
 <20130220202524.GC21725@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130220202524.GC21725@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 03:25:24PM -0500, Bob Copeland wrote:
> That takes the value read from the card, and multiplies it by
> ATH_RSSI_EP_MULTIPLIER, which is 1<<7.  So now it's in fixed-point
> with a 6-bit fractional part.

Sorry, off-by-one: 7-bit fractional part.

-- 
Bob Copeland %% www.bobcopeland.com
