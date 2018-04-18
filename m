Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60564 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbeDRKS3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 06:18:29 -0400
Subject: Re: [PATCH] mt76x2: fix is_mt7612 routine
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180417222718.17039-1-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <5489b1c9-b613-0254-75eb-11fe7d881447@nbd.name> (sfid-20180418_121836_157357_AD4B8083)
Date: Wed, 18 Apr 2018 12:18:27 +0200
MIME-Version: 1.0
In-Reply-To: <20180417222718.17039-1-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-18 00:27, Lorenzo Bianconi wrote:
> Fix is_mt7612 routine since asic version is set in mt76_dev revision
> field and not in mt76x2_dev one.
> Moreover remove mt76x2_dev rev field since it is never used in the
> driver
> 
> Fixes: 7bc04215a66b ('mt76: add driver code for MT76x2e')
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
