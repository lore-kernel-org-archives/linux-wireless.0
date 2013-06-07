Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab3FGLQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 07:16:55 -0400
Date: Fri, 7 Jun 2013 13:18:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v2 1/2] rt2x00: move extra_tx_headroom field from
 rt2x00_ops to rt2x00_dev
Message-ID: <20130607111849.GB5452@redhat.com> (sfid-20130607_131658_620472_4529B2C7)
References: <1370504180-10950-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370504180-10950-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 06, 2013 at 09:36:19AM +0200, Gabor Juhos wrote:
> The extra_tx_headroom field of struct rt2x00_ops
> indicates the extra TX headroom size required for
> a given device. This data is redundant, the value
> can be computed from the desc_size and winfo_size
> fields of the TX queues.
> 
> Move the extra_tx_headroom field to struct rt2x00_dev,
> compute its value in the probe routine and use the
> cached value in the rest of the code.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
> v2:
>   - remove the callbacks and compute the extra_tx_headroom
>     value from winfo_size and desc_size instead
>   - change subject

Thanks. For series:

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

