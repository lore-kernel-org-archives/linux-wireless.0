Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mamona.cetuc.puc-rio.br ([139.82.74.4]:34404 "EHLO
	mamona.cetuc.puc-rio.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbYCaW2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 18:28:42 -0400
Message-ID: <53141.201.36.161.238.1207002489.squirrel@mamao.cetuc.puc-rio.br> (sfid-20080331_232846_157594_4D00CBFB)
In-Reply-To: <200804010010.15705.IvDoorn@gmail.com>
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
    <200804010010.15705.IvDoorn@gmail.com>
Date: Mon, 31 Mar 2008 19:28:09 -0300 (BRT)
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
From: "Felipe Maya" <fmay@cetuc.puc-rio.br>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: "Felipe Maya" <fmay@cetuc.puc-rio.br>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configuration (kernel 2.6.23.1) seems OK (mac80211  132112  4
rc80211_simple,rt2500pci,rt2x00pci,rt2x00lib), but when I try to connect
with another machine in a simples Ad-Hoc mode, don't transmit anything,
remaining invisible with 'iwlist scan' command. While with the
serialmonkey driver run OK.




> Hi,
>
>> Is the last kernel code working with RaLink RT2500 802.11g
>> Cardbus/mini-PCI?
>
> With 'latest' do you mean:
>  latest 2.6.25-rc kernel?
>  latest wireless-testing git snapshot
>  latest rt2x00 git snapshot
>
> The latter 2 should work fine, the first one has known issues
> but the state variates per person.
>
>> In my machine don't work, but with the serialmonkey driver is well.
>>
>> (http://rt2x00.serialmonkey.com/rt2500-cvs-daily.tar.gz)
>>
>> Somebody can help me to configure the rt2x00 driver in order to run
>> ieee80211 module.
>
> How are you configuring the interface?
> What tools are you using?
> Do you get error messages?
> Is there any other information that might be usefull for understanding
> this bug?
>
> Ivo
>
>


