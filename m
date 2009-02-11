Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZBKQMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 11:12:50 -0500
Subject: Re: [PATCH 0/3] iwlwifi driver updates 02/10/2009
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1234307944-21820-1-git-send-email-reinette.chatre@intel.com>
References: <> <1234307944-21820-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 08:16:27 -0800
Message-Id: <1234368987.23593.35.camel@rc-desk> (sfid-20090211_171254_491539_FC1C3A93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 15:19 -0800, Chatre, Reinette wrote:
> Two cleanups and a fix to configure 5000 series FAT channels correctly.
> 
> [PATCH 1/3] iwlwifi: use pci registers defined in pci_regs.h
> [PATCH 2/3] iwlwifi: drop PCIe workaround applicable for development boards
> [PATCH 3/3] iwlwifi: fix FAT channel config for 5000 series

John,

Two of these patches have a duplicate "From:" line that will cause
git-am to include this information in the commit message.

Should I resend?

Reinette

