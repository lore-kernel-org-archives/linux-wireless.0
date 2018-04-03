Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48782 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752992AbeDCTKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:10:54 -0400
Subject: Re: [PATCH] mt76x2: make mt76x2_mac_reset routine static
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1522767292.git.lorenzo.bianconi@redhat.com>
 <3ac4534e4e14515843c8cb5fbd9accecfcef40d0.1522767292.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <85088454-3b76-b39c-e6f4-ad2e8d529c82@nbd.name> (sfid-20180403_211057_191586_4395857D)
Date: Tue, 3 Apr 2018 21:10:50 +0200
MIME-Version: 1.0
In-Reply-To: <3ac4534e4e14515843c8cb5fbd9accecfcef40d0.1522767292.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-03 17:01, Lorenzo Bianconi wrote:
> Add static qualifier to mt76x2_mac_reset routine and remove the
> prototype from mt76x2_mac.h since it is used just in mt76x2_init.c
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
