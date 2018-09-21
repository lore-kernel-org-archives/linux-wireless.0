Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55822 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbeIUWAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 18:00:02 -0400
Subject: Re: [PATCH] mt76x2: fix tx power configuration for VHT mcs 9
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1537538173.git.lorenzo.bianconi@redhat.com>
 <4e0f2495ae0d8effa82b8deae1c35b9abc0a5a2a.1537538173.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <aeff44cc-ce9b-a2ed-76cd-d49d0ac1619e@nbd.name> (sfid-20180921_181031_458810_E0243E86)
Date: Fri, 21 Sep 2018 18:10:26 +0200
MIME-Version: 1.0
In-Reply-To: <4e0f2495ae0d8effa82b8deae1c35b9abc0a5a2a.1537538173.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-21 15:57, Lorenzo Bianconi wrote:
> Fix tx power configuration for VHT 1SS/STBC mcs 9 since
> in MT_TX_PWR_CFG_{8,9} mcs 8,9 bits are GENMASK(21,16) and
> GENMASK(29,24) while GENMASK(15,6) are marked as reserved
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Merged, thanks.

- Felix
