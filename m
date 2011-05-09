Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1EIT1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 15:27:09 -0400
Date: Mon, 9 May 2011 21:27:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.35] iwlwifi: add {ack,plpc}_check module parameters
Message-ID: <20110509192705.GA5087@redhat.com> (sfid-20110509_212713_358438_8C933E3E)
References: <1304968943-27633-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304968943-27633-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 09, 2011 at 09:22:23PM +0200, Stanislaw Gruszka wrote:
> commit b7977ffaab5187ad75edaf04ac854615cea93828 upstream.
> 
> Add module ack_check, and plcp_check parameters. Ack_check is disabled
> by default since is proved that check ack health can cause troubles.
> Plcp_check is enabled by default.
> 
> This prevent connection hangs with "low ack count detected" messages.
> 
> Resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=666646
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Oops, this should go to stable.

Sorry,
Stanislaw
