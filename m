Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34639 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaK1L5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 06:57:07 -0500
Date: Fri, 28 Nov 2014 12:57:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] nfc drivers: don't include linux/unaligned/access_ok.h
Message-ID: <20141128115703.GE29389@ribalta.mp.intel.com> (sfid-20141128_125711_608481_74DDC966)
References: <1416428242-9942-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416428242-9942-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Nov 19, 2014 at 09:17:22PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is a specific implementation, <asm/unaligned.h> is the
> multiplexer that has the arch-specific knowledge of which
> of the implementations needs to be used, so include that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/nfc/pn544/i2c.c    | 2 +-
>  drivers/nfc/st21nfca/i2c.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
