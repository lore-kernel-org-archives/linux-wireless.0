Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64709 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0LPQm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 11:42:27 -0500
Received: by qwa26 with SMTP id 26so3418700qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 08:42:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0A33E2.9090509@pcuf.fi>
References: <4D0A33E2.9090509@pcuf.fi>
Date: Thu, 16 Dec 2010 17:42:26 +0100
Message-ID: <AANLkTinxi_VrCeboC0j2T_oMtQxvYP_oAzmXXr4KNetA@mail.gmail.com>
Subject: Re: rt2400pci.ko and it's AES/WPA2 support [Not subscribed to the list]
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Jar <jar@pcuf.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


> I can't find direct answer from the net archives. But in case of someone
> knows: Does the rt2400pci.ko support AES encryption and/or WPA2 in newest
> kernels and wpa_supplicant?

Yes, it does support it. It is all software encryption though, since there
is no hardware acceleration possible with this hardware.

Ivo
