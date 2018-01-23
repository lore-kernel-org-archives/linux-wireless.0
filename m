Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35850 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbeAWKje (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 05:39:34 -0500
Subject: Re: [PATCH v2] mt76x2: init: disable all pending tasklets during
 device removal
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org
References: <cover.1516697336.git.lorenzo.bianconi@redhat.com>
 <612e527f5358f4d7d465f21fc72b5b649dce5f40.1516697336.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <1d791ba7-5708-cbe5-5c74-09a6abc3c6ca@nbd.name> (sfid-20180123_113937_520067_86F599E6)
Date: Tue, 23 Jan 2018 11:39:33 +0100
MIME-Version: 1.0
In-Reply-To: <612e527f5358f4d7d465f21fc72b5b649dce5f40.1516697336.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-23 10:03, Lorenzo Bianconi wrote:
> There is a possible race in mt76x2_stop_hardware() since pre_tbtt and
> dfs tasklets could run during driver cleanup. Fix it disabling all
> pending tasklets during device removal
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
