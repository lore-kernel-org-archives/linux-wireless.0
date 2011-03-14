Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab1CNTXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 15:23:38 -0400
Subject: Re: [PATCH] iwl3945: do not deprecate software scan
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1300108506-15490-1-git-send-email-sgruszka@redhat.com>
References: <1300108506-15490-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 12:21:20 -0700
Message-ID: <1300130480.24333.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-14 at 06:15 -0700, Stanislaw Gruszka wrote:
> Software scanning can be used for workaround some performance problems,
> so do not deprecate it.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlegacy/iwl3945-base.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 


