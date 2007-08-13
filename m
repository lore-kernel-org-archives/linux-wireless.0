Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:50731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXHMUAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 16:00:48 -0400
Received: by nf-out-0910.google.com with SMTP id g13so572246nfb
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2007 13:00:47 -0700 (PDT)
Message-ID: <46C0B89E.3080505@gmail.com>
Date: Mon, 13 Aug 2007 22:01:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	jbenc@suse.cz, flamingice@sourmilk.net, jeff@garzik.org
Subject: Re: [PATCH 2/4] Net: mac80211, remove bitfields from struct ieee80211_txrx_data
References: <2653412025907217317@wsc.cz> <1187009078.27916.109.camel@johannes.berg>
In-Reply-To: <1187009078.27916.109.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg napsal(a):
> On Sun, 2007-08-12 at 15:08 +0200, Jiri Slaby wrote:
> 
>> -	unsigned int fragmented:1; /* whether the MSDU was fragmented */
>> +	/* whether the MSDU was fragmented */
>> +#define IEEE80211_TXRXD_FRAGMENTED		BIT(0)
>> +#define IEEE80211_TXRXD_TXUNICAST		BIT(1)
>> +#define IEEE80211_TXRXD_TXPS_BUFFERED		BIT(2)
>> +#define IEEE80211_TXRXD_TXPROBE_LAST_FRAG	BIT(3)
>> +#define IEEE80211_TXRXD_RXIN_SCAN		BIT(4)
> 
> I know this isn't the style currently used, but could you put these
> definitions before the struct declaration? That way, kerneldoc doesn't
> totally screw up.

OK

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
