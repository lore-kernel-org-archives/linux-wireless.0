Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20238 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbcEAVkb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2016 17:40:31 -0400
Date: Sun, 1 May 2016 23:40:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: =?iso-8859-1?Q?Cl=E9ment?= Perrochaud
	<clement.perrochaud@effinnov.com>,
	Charles Gorand <charles.gorand@effinnov.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND] nfc: Drop owner assignment from i2c_driver
Message-ID: <20160501214026.GB19653@zurbaran.home> (sfid-20160501_234050_395015_3297E64E)
References: <1459299064-20644-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459299064-20644-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Krzysztof,

On Wed, Mar 30, 2016 at 09:51:04AM +0900, Krzysztof Kozlowski wrote:
> i2c_driver does not need to set an owner because i2c_register_driver()
> will set it.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> The coccinelle script which generated the patch was sent here:
> http://www.spinics.net/lists/kernel/msg2029903.html
> ---
>  drivers/nfc/nxp-nci/i2c.c  | 1 -
>  drivers/nfc/pn544/i2c.c    | 1 -
>  drivers/nfc/st-nci/i2c.c   | 1 -
>  drivers/nfc/st21nfca/i2c.c | 1 -
>  4 files changed, 4 deletions(-)
Patch applied to nfc-next, thanks.

Cheers,
Samuel.
