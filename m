Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45226 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753015AbdLNP36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:29:58 -0500
Subject: Re: [PATCH] mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: colin.king@canonical.com, linux-wireless@vger.kernel.org
References: <cover.1513248071.git.lorenzo.bianconi@redhat.com>
 <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ec1e57a0-e4cb-668c-8cde-e9e4e24095ac@nbd.name> (sfid-20171214_163003_198991_DCED9BFD)
Date: Thu, 14 Dec 2017 16:29:56 +0100
MIME-Version: 1.0
In-Reply-To: <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-14 11:46, Lorenzo Bianconi wrote:
> Fix typo in 5GHz power vs channel eeprom parsing
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
