Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61324 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0GWTD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 15:03:27 -0400
Received: by pzk26 with SMTP id 26so198545pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 12:03:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimfc3NY46aYqPM5Ys2i9vpm2_qr5-kgsvc3sdkx@mail.gmail.com>
References: <AANLkTimfc3NY46aYqPM5Ys2i9vpm2_qr5-kgsvc3sdkx@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 23 Jul 2010 12:03:07 -0700
Message-ID: <AANLkTimpwMyfcvRGnJ1JfZP+F=4nFNT5Ra3pB3vse1LM@mail.gmail.com>
Subject: Re: Atheros 0cf3:b003
To: Maximi89 <maximi89@gmail.com>
Cc: Stephen Chen <Stephen.Chen@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/7/23 Maximi89 <maximi89@gmail.com>:
> Hola Luis, conoces ese ID?, Atheros 0cf3:b003
> Es efectivamente un AR9271?

No, cual tarjeta es esa? Las que tenemos son estos:

static struct usb_device_id ath9k_hif_usb_ids[] = {
        { USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
        { USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
        { USB_DEVICE(0x0cf3, 0x7010) }, /* Atheros */
        { USB_DEVICE(0x0cf3, 0x7015) }, /* Atheros */
        { USB_DEVICE(0x0846, 0x9030) }, /* Netgear N150 */
        { USB_DEVICE(0x0846, 0x9018) }, /* Netgear WNDA3200 */
        { USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
        { USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
        { USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
        { USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
        { USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
        { },
};

Stephen, have you heard of 0cf3:b003 as an ar9271 or HB94 card?

  Luis
