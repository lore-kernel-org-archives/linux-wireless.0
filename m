Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbbFHVc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 17:32:29 -0400
Date: Mon, 8 Jun 2015 23:32:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [char-misc-next] NFC: microread: drop unused variable
Message-ID: <20150608213226.GF5089@ribalta.mp.intel.com> (sfid-20150608_233417_981973_C0222F4E)
References: <1431005910-9284-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431005910-9284-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

On Thu, May 07, 2015 at 04:38:30PM +0300, Tomas Winkler wrote:
> In microread_i2c_irq_thread_fn 'client' set but not used
> 
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/nfc/microread/i2c.c | 3 ---
>  1 file changed, 3 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
