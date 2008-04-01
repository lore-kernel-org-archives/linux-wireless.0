Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:25437 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbYDAIvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 04:51:37 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2509080wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 01:51:36 -0700 (PDT)
Message-ID: <a32f33a40804010151v6cd1c6d6w9c4e6cc03b7db01d@mail.gmail.com> (sfid-20080401_095142_448671_13969D24)
Date: Tue, 1 Apr 2008 10:51:36 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Felipe Maya" <fmay@cetuc.puc-rio.br>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <53141.201.36.161.238.1207002489.squirrel@mamao.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
	 <200804010010.15705.IvDoorn@gmail.com>
	 <53141.201.36.161.238.1207002489.squirrel@mamao.cetuc.puc-rio.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The configuration (kernel 2.6.23.1) seems OK (mac80211  132112  4
>  rc80211_simple,rt2500pci,rt2x00pci,rt2x00lib),

I still have the same question, what version?
kernel 2.6.23 does not contain rt2x00, so what version are you using?

> but when I try to connect
>  with another machine in a simples Ad-Hoc mode, don't transmit anything,
>  remaining invisible with 'iwlist scan' command. While with the
>  serialmonkey driver run OK.

Again same questions:
How are you configuring the interface?
What tools are you using?
Do you get an error messages?
Is there any other information that might be useful for understanding this bug?

Ivo
