Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.230]:41595 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXBMPK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 10:10:27 -0500
Received: by qb-out-0506.google.com with SMTP id z8so935189qbc
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2007 07:10:26 -0800 (PST)
Message-ID: <b6a2187b0702130710s217281c4k5ed227995c09c878@mail.gmail.com>
Date: Tue, 13 Feb 2007 23:10:24 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "=?ISO-8859-1?Q?Ismail_D=F6nmez?=" <ismail@pardus.org.tr>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Cc: "James Ketrenos" <jketreno@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <200702131558.48987.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
References: <45CCE3CA.4050904@linux.intel.com>
	 <200702131558.48987.ismail@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, Ismail D=F6nmez <ismail@pardus.org.tr> wrote:

> Tried this is on a patched 2.6.20 kernel with ipw3945 device and it a=
lways
> puts the card in 802.11a mode instead of 802.11bg mode.
>
> Ideas?


Before running  "iwconfig wlan0 channel 8",  the card is set to
802.11a mode. iwconfig shows rate at 54Mb/s. But after setting the
channel, it sets to 802.11b mode, and I can't find a way to change
from 11Mb/s to 54MB/s.

"iwlist eth0 rate" only show up to 11Mb/s.

So, my problem is the card is always in 802.11b mode.

Thanks,
Jeff.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
