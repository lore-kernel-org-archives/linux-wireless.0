Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32898 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2EISNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 14:13:19 -0400
Received: by pbbrp8 with SMTP id rp8so806231pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 11:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABF+-6UWRy+KZMOFo12z3n7hPjWH-mUN203nQq_0rNb1Yjj7dg@mail.gmail.com>
References: <CABF+-6UWRy+KZMOFo12z3n7hPjWH-mUN203nQq_0rNb1Yjj7dg@mail.gmail.com>
Date: Wed, 9 May 2012 20:13:18 +0200
Message-ID: <CAMG6FYhArTmZyhraGCR4aHjcXZFAzFi9_UL9uK11XnvTxeQKOQ@mail.gmail.com> (sfid-20120509_201326_596342_993571F5)
Subject: Re: [PATCHv2 12/21] cw1200: sta.*, mac80211 STA callbacks.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

>>+                      priv->conf_listen_interval =
>>+                              (*((u16 *)pElement->data+1) >> 7) & 0x1F;
>
> The above code in the cw1200_parse_SDD_file function does not appear
> to take into account the endianess of the host.  Is this a problem?

Yepp, thank you for pointing out :).

Dmitry
