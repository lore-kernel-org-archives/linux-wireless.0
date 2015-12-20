Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbLTXIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 18:08:39 -0500
Date: Mon, 21 Dec 2015 00:08:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Saurabh Sengar <saurabh.truth@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: added the rx delay parameter for nfcsim workqueue
Message-ID: <20151220230836.GA6306@zurbaran.home> (sfid-20151221_000942_671924_ED42834B)
References: <1450637970-4990-1-git-send-email-saurabh.truth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450637970-4990-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Saurabh,

On Mon, Dec 21, 2015 at 12:29:30AM +0530, Saurabh Sengar wrote:
> added the rx delay parameter as a device tunable parameter.
> 
> Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
> ---
> This is a follow up patch after the review comments by Samuel Ortiz
> on the initial patch.
> Below is the link to original patch which implemented this parameter
> as sysfs entry:
> https://lkml.org/lkml/2015/12/20/118
>  drivers/nfc/nfcsim.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
