Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47378 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1KBTq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 15:46:27 -0400
Date: Wed, 2 Nov 2011 15:44:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.1] iwlwifi: remove un-needed out_iounmap label
Message-ID: <20111102194433.GA16597@tuxdriver.com> (sfid-20111102_204636_538609_3BC69E07)
References: <1319765778-8868-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319765778-8868-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2011 at 06:36:18PM -0700, Wey-Yi Guy wrote:
> out_iounmap is no longer used, remove it
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> apply this patch after "iwlwifi-allow-pci_enable_msi-fail.patch"

FWIW, I combined this patch with the earlier one.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
