Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:13826 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbcGSV3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 17:29:04 -0400
Date: Tue, 19 Jul 2016 23:28:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: null-ify info->ram_patch when firmware is released
Message-ID: <20160719212858.GA2274@zurbaran.home> (sfid-20160719_232926_195257_5B96AD56)
References: <1468587633-25766-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468587633-25766-1-git-send-email-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

On Fri, Jul 15, 2016 at 02:00:33PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> When the firmware is released for info->ram_patch currently
> info->otp_patch is being nullified and not info->ram_patch.
> This looks like a cut-n-paste coding error. Fix this by
> nullifing the correct field.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/fdp/fdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
