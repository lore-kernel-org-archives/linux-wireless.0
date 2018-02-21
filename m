Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:24176 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932318AbeBUQ0C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:26:02 -0500
Date: Wed, 21 Feb 2018 21:55:54 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 02/12] staging: wilc1000: fix too many leading tabs
 warning in sdio_clear_int_ext()
Message-ID: <20180221215554.4f38c3e5@ajaysk-VirtualBox> (sfid-20180221_172606_346575_3AF85A56)
In-Reply-To: <7576dfcf-caab-3b2d-c4bb-e1ea29db2fce@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
        <1518793909-15573-3-git-send-email-ajay.kathat@microchip.com>
        <7576dfcf-caab-3b2d-c4bb-e1ea29db2fce@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Claudiu,

On Mon, 19 Feb 2018 15:33:09 +0200
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> Since you re-factor this, as I suggested in patch:
> "[PATCH 6/6] staging: wilc1000: fix line over 80 chars in
> wilc_spi_clear_int_ext()" form your previous series:
> "fix line over 80 char & coding style in wilc_spi.c",
> for code starting here:


Submitted a new patch "[PATCH 3/4] staging: wilc1000: refactor
wilc_spi_clear_int_ext() by using GENMASK macro" 
&
"[PATCH 4/4] staging: wilc1000: refactor sdio_clear_int_ext() 
by using GENMASK macro" which contain changes as suggested.

> 
> and ending here, further improvements could be done. Since the current series
> was accepted, maybe add these to a todo list and review them later?

For both SPI and SDIO the changes are done. Please review and let me know
if you any inputs.


regards,
ajay
