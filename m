Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3KAJb0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 05:31:26 -0400
Date: Fri, 1 Nov 2013 10:31:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Salil Kapur <salilkapur93@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: mei_phy: using kfree_skb() instead of kfree()
Message-ID: <20131101093113.GB31890@zurbaran> (sfid-20131101_103142_877746_D3EC2062)
References: <1383241666-3806-1-git-send-email-salilkapur93@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383241666-3806-1-git-send-email-salilkapur93@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Salil,

On Thu, Oct 31, 2013 at 11:17:46PM +0530, Salil Kapur wrote:
> using kfree_skb() instead of kfree() for struct sk_buff
> 
> Signed-off-by: Salil Kapur <salilkapur93@gmail.com>
> ---
>  drivers/nfc/mei_phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
