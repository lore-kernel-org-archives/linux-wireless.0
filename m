Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:51938 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754548AbeGJDOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 23:14:18 -0400
Date: Mon, 9 Jul 2018 20:14:10 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, dcaratti@redhat.com
Subject: Re: [PATCH 0/2] enable 802.11w in mt7601u driver
Message-ID: <20180709201410.67a77f31@cakuba.lan> (sfid-20180710_051426_708849_BF9C948F)
In-Reply-To: <cover.1531130155.git.lorenzo.bianconi@redhat.com>
References: <cover.1531130155.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon,  9 Jul 2018 12:20:25 +0200, Lorenzo Bianconi wrote:
> Lorenzo Bianconi (1):
>   mt7601u: use sw encryption for hw unsupported ciphers
> 
> Davide Caratti (1):
>   mt7601u: expose 802.11w support
> 
>  drivers/net/wireless/mediatek/mt7601u/init.c |  1 +
>  drivers/net/wireless/mediatek/mt7601u/main.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)

Acked-by: Jakub Kicinski <kubakici@wp.pl>
