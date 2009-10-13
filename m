Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZJMMof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 08:44:35 -0400
From: "Zhu, Yi" <yi.zhu@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Oct 2009 20:44:18 +0800
Subject: RE: [PATCH V3] iwlwifi: use paged Rx
Message-ID: <AFAB8585072C7E48BC5C6F9C87F9B79703BEC69923@pdsmsx502.ccr.corp.intel.com>
References: <1255079985-17282-1-git-send-email-yi.zhu@intel.com>
 <20091012142002.GA2687@dhcp-lab-161.englab.brq.redhat.com>
 <1255421948.3719.363.camel@debian>
 <20091013115110.GA2639@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091013115110.GA2639@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> > Which case? The linear one is the same as the current implementation.
> 
> Considering swcrypt for example. This patch make things worse as we still
> need to do the same skb allocation as before, plus additional pages allocation,
> plus additional memcpy. No ?

Yes. But software encryption is only used for debugging purpose by iwlagn.

Thanks,
-yi
