Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:13299 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932851AbeBUQdX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:33:23 -0500
Subject: Re: [PATCH 02/12] staging: wilc1000: fix too many leading tabs
 warning in sdio_clear_int_ext()
To: Ajay Singh <ajay.kathat@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
 <1518793909-15573-3-git-send-email-ajay.kathat@microchip.com>
 <7576dfcf-caab-3b2d-c4bb-e1ea29db2fce@microchip.com>
 <20180221215554.4f38c3e5@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <b1d1596a-c320-d85f-18db-619a255c1a47@microchip.com> (sfid-20180221_173326_976469_3BBB3FBE)
Date: Wed, 21 Feb 2018 18:33:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180221215554.4f38c3e5@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ajay,

Sure, I will take a look.

Thank you,
Claudiu

On 21.02.2018 18:25, Ajay Singh wrote:
> Hi Claudiu,
> 
> On Mon, 19 Feb 2018 15:33:09 +0200
> Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> 
>> Since you re-factor this, as I suggested in patch:
>> "[PATCH 6/6] staging: wilc1000: fix line over 80 chars in
>> wilc_spi_clear_int_ext()" form your previous series:
>> "fix line over 80 char & coding style in wilc_spi.c",
>> for code starting here:
> 
> 
> Submitted a new patch "[PATCH 3/4] staging: wilc1000: refactor
> wilc_spi_clear_int_ext() by using GENMASK macro" 
> &
> "[PATCH 4/4] staging: wilc1000: refactor sdio_clear_int_ext() 
> by using GENMASK macro" which contain changes as suggested.
> 
>>
>> and ending here, further improvements could be done. Since the current series
>> was accepted, maybe add these to a todo list and review them later?
> 
> For both SPI and SDIO the changes are done. Please review and let me know
> if you any inputs.
> 
> 
> regards,
> ajay
> 
