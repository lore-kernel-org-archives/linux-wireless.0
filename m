Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab0HDTSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 15:18:16 -0400
Subject: Re: [PATCH 0/8] iwlwifi update for 2.6.36
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20100804190320.GQ17666@tuxdriver.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20100804190320.GQ17666@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 04 Aug 2010 12:17:40 -0700
Message-Id: <1280949460.17120.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2010-08-04 at 20:03 +0100, John W. Linville wrote:
> On Sat, Jul 31, 2010 at 08:34:04AM -0700, Wey-Yi Guy wrote:
> > We move "Thermal throttling" related functions out of power management
> > into it own file.
> > We also reduce the warning level for "BA scd_flow not match" to
> > avoid flood the syslog when condition detected.
> > We also track IBSS manager status with uCode beacon notification.
> > 
> > Johannes Berg (2):
> 
> >   iwlwifi: fix compile warning
> > 
> > Wey-Yi Guy (6):
> 
> >   iwlwifi: BA scd_flow not match condition detected
> >   iwlagn: fix typo in ucode_bt_stats_read debugfs
> 
> I'm applying these directly as fixes intended for 2.6.36.  I will
> apply the others to wireless-next-2.6 after the merge window closes
> for 2.6.36.
> 
Thank you very much 

Wey

