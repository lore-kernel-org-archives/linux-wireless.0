Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:44666 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751163Ab0BQHBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 02:01:16 -0500
Message-ID: <4B7B9438.9020601@free.fr>
Date: Wed, 17 Feb 2010 08:01:12 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Bob Copeland <me@bobcopeland.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix TX/RX padding for all frames
References: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr> <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com> <4B79C565.1050701@free.fr> <20100216004717.GA6844@hash.localnet> <4B7B027D.70701@free.fr> <20100217061523.GA5147@jm.kir.nu>
In-Reply-To: <20100217061523.GA5147@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen a écrit :
> On Tue, Feb 16, 2010 at 09:39:25PM +0100, Benoit PAPILLAULT wrote:
>   
>> I don't have an ath5k based card at hand. I will try to grab one and
>> will give an example of said frame. Basically, I followed the same
>> strategy for ath9k already.
>>     
>
> Are you saying that this patch has not actually been tested at all on
> ath5k and it was just based on the changes you did for ath9k? If that is
> the case, I would suggest running the tests before actually applying
> this. We should really not depend on undocumented hardware behavior to
> remain the same between different revisions. That's why I did not like
> the changes in ath9k and would not exactly like extending that to even
> more different chips taken into account that none of this is needed for
> normal use of the card.
>  
>   
No. It has been tested the same way I tested ath9k, ie using 2 cards in 
monitor mode and reading/writing 802.11 frame and checking that they are 
the same on the other side. I just need to swap my ath9k based card 
(AR9280) with an ath5k based card (AR5212) in my laptop and redo the 
test. I will do so in a couple of days.

Regards,
Benoit

