Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40434 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753211AbeCQVDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 17:03:35 -0400
Subject: Re: [PATCH] mt76x2: fix possible NULL pointer dereferencing in
 mt76x2_tx()
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180317112927.18299-1-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f0f4efc6-d3d0-1985-6b97-b30b72f0c0fc@nbd.name> (sfid-20180317_220338_439167_517B71FB)
Date: Sat, 17 Mar 2018 22:03:33 +0100
MIME-Version: 1.0
In-Reply-To: <20180317112927.18299-1-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-17 12:29, Lorenzo Bianconi wrote:
> Fix a theoretical NULL pointer dereferencing in mt76x2_tx routine that
> can occurs for injected frames in a monitor vif since vif pointer could
> be NULL for that interfaces
> 
> Fixes: 23405236460b ("mt76: fix transmission of encrypted mgmt frames")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
