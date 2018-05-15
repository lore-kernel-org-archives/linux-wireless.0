Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45250 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbeEOLU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 07:20:27 -0400
Subject: Re: [PATCH] mt76x2: apply coverage class on slot time too
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, luca.bisti@gmail.com,
        gaetano.catalli@gmail.com
References: <20180515100814.491-1-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <7b8d51cc-2c54-0db4-311b-19a89b5d9c7f@nbd.name> (sfid-20180515_132106_612139_323BBA98)
Date: Tue, 15 May 2018 13:20:24 +0200
MIME-Version: 1.0
In-Reply-To: <20180515100814.491-1-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-15 12:08, Lorenzo Bianconi wrote:
> According to 802.11-2007 17.3.8.6 (slot time), the slot time should
> be increased by 3 us * coverage class. Taking into account coverage
> class in slot time configuration allows to increase by an order of
> magnitude the throughput on a 4Km link in a noisy environment
> 
> Tested-by: Luca Bisti <luca.bisti@gmail.com>
> Tested-by: Gaetano Catalli <gaetano.catalli@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
