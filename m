Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZEZRRf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 13:17:35 -0400
Subject: Re: [PATCH] iwlwifi: fix merge error
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1243028275-15833-1-git-send-email-reinette.chatre@intel.com>
References: <1243028275-15833-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:24:12 -0700
Message-Id: <1243358652.7624.3008.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Fri, 2009-05-22 at 14:37 -0700, Chatre, Reinette wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> This hunk of code was removed in patch "iwlwifi: do not
> cancel delayed work inside spin_lock_irqsave" submitted at
> http://marc.info/?l=linux-wireless&m=124267503030042&w=2
> 
> This same patch in this repo does not remove this hunk.
> Remove it here.
> 

The above link is to the patch against 2.6.30 that you fixed for us. I
tried to find the original patches we sent against 2.6.30 and
wireless-testing, but could not find them in the mail archives. The
original patch against wireless-testing also removes this hunk. I do not
know why I cannot find it in the archives.

Reinette


