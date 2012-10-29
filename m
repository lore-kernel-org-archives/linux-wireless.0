Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758549Ab2J2LAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 07:00:31 -0400
Date: Mon, 29 Oct 2012 12:00:28 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] NFC: Move pn544.h to linux/platform_data/
Message-ID: <20121029110028.GG5411@sortiz-mobl> (sfid-20121029_120040_081578_052EE3E9)
References: <1351104326-5206-1-git-send-email-marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351104326-5206-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Wed, Oct 24, 2012 at 11:45:26AM -0700, Marcel Holtmann wrote:
> The pn544.h just provides the platform data struct and defines and
> nothing else. So move it to to linux/platform_data/ now.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  drivers/nfc/pn544_hci.c             |  2 +-
>  include/linux/nfc/pn544.h           | 44 -------------------------------------
>  include/linux/platform_data/pn544.h | 44 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+), 45 deletions(-)
>  delete mode 100644 include/linux/nfc/pn544.h
>  create mode 100644 include/linux/platform_data/pn544.h
We moved the pn544 driver into his own directory, so I applied this patch to
my nfc-next branch after fixing it up.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
