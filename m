Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51754 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab0EDSjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 14:39:55 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: HT rate warning with openwrt AP using wireless-compat and ath9k
References: <87och0j7jj.fsf@purkki.valot.fi>
	<w2q43e72e891005031610uf6b912aduf271b0a97933d68a@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 04 May 2010 21:39:54 +0300
In-Reply-To: <w2q43e72e891005031610uf6b912aduf271b0a97933d68a@mail.gmail.com> (Luis R. Rodriguez's message of "Mon\, 3 May 2010 16\:10\:10 -0700")
Message-ID: <87d3xbjyth.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>
> Can you enable ATH_DBG_XMIT on the box and see if this comes up?
>
>         ATH_DBG_XMIT            = 0x00000080,
>
> So just modprobe ath9k debug=0x80. I'll send an RFT patch soon.

I'm travelling right now and the AP is at home. I can test it
when I get back home, hopefully in two weeks.

/me prays for the volcano gods

-- 
Kalle Valo
