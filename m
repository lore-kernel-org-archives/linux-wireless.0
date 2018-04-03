Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48706 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752688AbeDCTKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:10:14 -0400
Subject: Re: [PATCH] mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1522766852.git.lorenzo.bianconi@redhat.com>
 <b38ac7608bc8d7cba2a9b7178bd755fae0fc7c6b.1522766852.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <97a0d771-ece9-fa27-c6c9-d6599b92cea0@nbd.name> (sfid-20180403_211016_834917_60396EBF)
Date: Tue, 3 Apr 2018 21:10:11 +0200
MIME-Version: 1.0
In-Reply-To: <b38ac7608bc8d7cba2a9b7178bd755fae0fc7c6b.1522766852.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-03 16:52, Lorenzo Bianconi wrote:
> Remove unnecessary MT_TX_ALC_CFG_4 configuration since register value
> has already set to 0 on 5GHz band
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
If I read the code correctly, I think it makes more sense to remove the
previous initialization, in order to have the writes to that register
grouped together.

- Felix
