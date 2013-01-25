Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42426 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3AYNAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 08:00:08 -0500
Received: by mail-lb0-f176.google.com with SMTP id s4so652962lbc.7
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 05:00:06 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: rt2800 does not support HT40 in managed mode
Date: Fri, 25 Jan 2013 14:00:03 +0100
Message-ID: <2031699.Fe3lSbzTJv@sylvesterjr.pats.ua.ac.be> (sfid-20130125_140013_046710_B369F9B5)
In-Reply-To: <CAGXE3d9+XjVA4GNc37mZyNjE59xom2FMDhNZx_DFyzax8eXfkQ@mail.gmail.com>
References: <2074978.Uifvhs4VDD@sylvesterjr.pats.ua.ac.be> <CAGXE3d9+XjVA4GNc37mZyNjE59xom2FMDhNZx_DFyzax8eXfkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2013 13:13:27 Helmut Schaa wrote:
> Maybe there were other APs around forcing hostapd to fall back to 
HT20 (see
> ieee80211n_allowed_ht40_channel_pair in hostapd source code)?

No, the Wi-Spy did not detect any other activity in the channel. 
Furthermore, testing with a commercial access point, it worked flawlessly 
with HT40.

Best regards,
Erwin

