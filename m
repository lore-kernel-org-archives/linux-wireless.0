Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41786 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeIVR6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:58:11 -0400
Subject: Re: [PATCH] mt76: usb: remove WARN_ON in mt76u_get_rx_entry_len
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <cover.1537272524.git.lorenzo.bianconi@redhat.com>
 <c9d8d73f3353c2ad953d8a298c52a32922ed2bcc.1537272524.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <36091045-a13e-4287-4b8b-9a985ca91d14@nbd.name> (sfid-20180922_140524_716005_1BF3E3A8)
Date: Sat, 22 Sep 2018 14:04:47 +0200
MIME-Version: 1.0
In-Reply-To: <c9d8d73f3353c2ad953d8a298c52a32922ed2bcc.1537272524.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-18 14:12, Lorenzo Bianconi wrote:
> Remove not useful WARN_ON macros in mt76u_get_rx_entry_len routine
> since corrupted frames should just be silently discarded
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Merged, thanks.
