Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45242 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752671AbdLNPaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:30:22 -0500
Subject: Re: [PATCH 0/2] Fix two possible NULL pointer dereferencing issues
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
References: <cover.1513252573.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <c3dd0279-11d2-2ea8-c90d-361e7b95604b@nbd.name> (sfid-20171214_163026_473604_D00724CA)
Date: Thu, 14 Dec 2017 16:30:20 +0100
MIME-Version: 1.0
In-Reply-To: <cover.1513252573.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-14 13:03, Lorenzo Bianconi wrote:
> Lorenzo Bianconi (2):
>   mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
>   mt76: fix possible NULL pointer dereferencing in
>     mt76x2_mac_write_txwi()
For both patches:
Acked-by: Felix Fietkau <nbd@nbd.name>
