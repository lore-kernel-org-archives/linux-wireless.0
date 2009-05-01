Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZEAPwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 11:52:16 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: reinette chatre <reinette.chatre@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241179203.8086.3.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 01 May 2009 08:58:33 -0700
Message-Id: <1241193513.10498.97.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim,

On Fri, 2009-05-01 at 05:00 -0700, Maxim Levitsky wrote:
> Don't know if this is new regression, or just exposed race condition,
> but currently using rfkill, and/or s2disk sometimes leaves the card in
> state in which it can't scan.

Could you please provide more details of this scenario? 

> 
> Tested with and without hardware scanning.
> 
> It just returns -EBUSY till I reload the driver.
> 
> I use iwlwifi.git, iwl3945

Reinette

