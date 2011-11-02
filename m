Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1KBT5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 15:57:36 -0400
Subject: Re: [PATCH 3.1] iwlwifi: remove un-needed out_iounmap label
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111102194433.GA16597@tuxdriver.com>
References: <1319765778-8868-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20111102194433.GA16597@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 12:51:34 -0700
Message-ID: <1320263494.13578.13.camel@wwguy-ubuntu> (sfid-20111102_205739_866948_9F922D35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 12:44 -0700, John W. Linville wrote:
> On Thu, Oct 27, 2011 at 06:36:18PM -0700, Wey-Yi Guy wrote:
> > out_iounmap is no longer used, remove it
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> > apply this patch after "iwlwifi-allow-pci_enable_msi-fail.patch"
> 
> FWIW, I combined this patch with the earlier one.
> 
thank you, should do that at the first place :-)

Wey


