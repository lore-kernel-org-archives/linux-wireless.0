Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbYLCWze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 17:55:34 -0500
Subject: Re: [PATCH 0/5] Support for Intel(r) WiMax/WiFi Link 5050 Series
From: Dan Williams <dcbw@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
References: <> <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 17:54:31 -0500
Message-Id: <1228344872.25647.30.camel@localhost.localdomain> (sfid-20081203_235539_176858_862DE9C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-01 at 16:32 -0800, Reinette Chatre wrote:
> This series adds support for a member of the Intel(r)
>  WiMax/WiFi Link 5050 Series.
> 
> [PATCH 1/5] iwlwifi: 5150 add support for 5150
> [PATCH 2/5] iwlwifi: 5150 enable DC calibration
> [PATCH 3/5] iwlwifi: 5150 compute ct kill threshold
> [PATCH 4/5] iwlwifi: 5150 parametrize eeprom versions
> [PATCH 5/5] iwlwifi: 5150 enable LO, TXIQ and BB calibrations

Awesome, is the 5150 firmware available in the usual places now?  I
don't see it at:

http://intellinuxwireless.org/?n=Downloads

and unless I'm completely blind:

+#define IWL5150_MODULE_FIRMWARE "iwlwifi-5150" IWL5150_UCODE_API ".ucode"

new ucode is required :)

Dan


