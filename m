Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48722 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753061AbeDCTKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:10:35 -0400
Subject: Re: [PATCH] mt76x2: fix tssi initialization for 5GHz band
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1522766285.git.lorenzo.bianconi@redhat.com>
 <53d9322f1b5cafb832163b8ef93118aecc1ef3f1.1522766285.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <0bdecee8-36d1-ad75-a781-32a93e57219f@nbd.name> (sfid-20180403_211038_449431_DFCFC430)
Date: Tue, 3 Apr 2018 21:10:32 +0200
MIME-Version: 1.0
In-Reply-To: <53d9322f1b5cafb832163b8ef93118aecc1ef3f1.1522766285.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-03 16:45, Lorenzo Bianconi wrote:
> Fix mcu initial configuration for tssi calibration on 5GHz band
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
