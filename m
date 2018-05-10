Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58006 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966262AbeEJQ2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 12:28:05 -0400
Subject: Re: [PATCH] mt76x2: add a polling delay in mt76x2_mac_stop routine
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1525960967.git.lorenzo.bianconi@redhat.com>
 <e7c7fcf87f42a137472b8dfd1460a8d41a295bfa.1525960967.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f887a696-a98e-e45a-bb67-87895a33ee54@nbd.name> (sfid-20180510_182810_866676_C78108CC)
Date: Thu, 10 May 2018 18:28:03 +0200
MIME-Version: 1.0
In-Reply-To: <e7c7fcf87f42a137472b8dfd1460a8d41a295bfa.1525960967.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-10 16:06, Lorenzo Bianconi wrote:
> Add a usleep_range in mt76x2_mac_stop routine in order to add
> a polling delay checking values of MT_MAC_STATUS and IBI_R12 registers
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
