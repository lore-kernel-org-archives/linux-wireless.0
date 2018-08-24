Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:5913 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbeHXMU4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 08:20:56 -0400
Subject: Re: [PATCH 10/24] staging: wilc1000: move
 wilc_multicast_mac_addr_list to 'wilc_vif' struct
To: Ajay Singh <ajay.kathat@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-11-git-send-email-ajay.kathat@microchip.com>
 <92faa952-6722-cc9f-cccf-2275c4158a37@microchip.com>
 <20180823153021.3ad58351@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <eb7b4aa5-613e-9efc-4b5e-a926f8b23fb1@microchip.com> (sfid-20180824_104720_870867_CEBD9DC7)
Date: Fri, 24 Aug 2018 11:47:14 +0300
MIME-Version: 1.0
In-Reply-To: <20180823153021.3ad58351@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23.08.2018 13:00, Ajay Singh wrote:
> Unless ndo_set_rx_mode() gets called quickly I don't think there is any
> issue here. 

I don't agree with this.
