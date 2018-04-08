Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54998 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbeDHK4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Apr 2018 06:56:11 -0400
Subject: Re: [PATCH v2] mt76x2: remove unnecessary MT_TX_ALC_CFG_4
 configuration
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180403203019.8988-1-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <93eff665-23e2-a711-d502-aaf51de0adfd@nbd.name> (sfid-20180408_125616_886527_07814CB5)
Date: Sun, 8 Apr 2018 12:56:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180403203019.8988-1-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-03 22:30, Lorenzo Bianconi wrote:
> Remove unnecessary MT_TX_ALC_CFG_4 configuration since the register value
> will be properly set according to the usage of an external power amplifier
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
