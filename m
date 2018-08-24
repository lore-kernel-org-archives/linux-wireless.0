Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:4931 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeHXMVY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 08:21:24 -0400
Subject: Re: [PATCH 06/24] staging: wilc1000: move during_ip_timer &
 wilc_optaining_ip to 'wilc_vif' struct
To: Ajay Singh <ajay.kathat@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-7-git-send-email-ajay.kathat@microchip.com>
 <3b84cdbf-8f56-17a0-d6f5-75e6d6cd8295@microchip.com>
 <20180823151333.448c6606@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <eafee1d0-980b-5094-b57d-1ad9c5e1f79e@microchip.com> (sfid-20180824_104754_368838_15D4E600)
Date: Fri, 24 Aug 2018 11:47:20 +0300
MIME-Version: 1.0
In-Reply-To: <20180823151333.448c6606@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23.08.2018 12:43, Ajay Singh wrote:
> The idea was to keep private data related to 'wiphy priv'
> in 'wilc_priv' struct and 'netdev priv' related data in 'wilc_vif'
> struct.

OK, I see, agree!
