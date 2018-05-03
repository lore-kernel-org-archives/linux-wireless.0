Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40478 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbeECLig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 07:38:36 -0400
Subject: Re: [PATCH] mt76x2: fix avg_rssi estimation
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1525254116.git.lorenzo.bianconi@redhat.com>
 <62914ffe8256eb60af815fca6591473d67f5a639.1525254116.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <d34c1f73-802d-5d8c-e5dd-be005bd9b233@nbd.name> (sfid-20180503_133840_564322_FCF0C5A8)
Date: Thu, 3 May 2018 13:38:34 +0200
MIME-Version: 1.0
In-Reply-To: <62914ffe8256eb60af815fca6591473d67f5a639.1525254116.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-02 11:46, Lorenzo Bianconi wrote:
> Add leftover filter coefficients in IIR rssi estimation
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
