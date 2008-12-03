Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45602 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYLCXeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 18:34:07 -0500
Subject: Re: [PATCH 0/5] Support for Intel(r) WiMax/WiFi Link 5050 Series
From: reinette chatre <reinette.chatre@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1228344872.25647.30.camel@localhost.localdomain>
References: <> <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
	 <1228344872.25647.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 15:35:03 -0800
Message-Id: <1228347303.13338.77.camel@rc-desk> (sfid-20081204_003412_991520_E4E4160C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-03 at 14:54 -0800, Dan Williams wrote:
> On Mon, 2008-12-01 at 16:32 -0800, Reinette Chatre wrote:
> > This series adds support for a member of the Intel(r)
> >  WiMax/WiFi Link 5050 Series.
> > 
> > [PATCH 1/5] iwlwifi: 5150 add support for 5150
> > [PATCH 2/5] iwlwifi: 5150 enable DC calibration
> > [PATCH 3/5] iwlwifi: 5150 compute ct kill threshold
> > [PATCH 4/5] iwlwifi: 5150 parametrize eeprom versions
> > [PATCH 5/5] iwlwifi: 5150 enable LO, TXIQ and BB calibrations
> 
> Awesome, is the 5150 firmware available in the usual places now?  I
> don't see it at:
> 
> http://intellinuxwireless.org/?n=Downloads
> 
> and unless I'm completely blind:
> 
> +#define IWL5150_MODULE_FIRMWARE "iwlwifi-5150" IWL5150_UCODE_API ".ucode"
> 
> new ucode is required :)
> 

yes - new ucode is required but is not yet available for release. When
the ucode is released (we will announce it) it will be available in the
spot you mention above.

Reinette

