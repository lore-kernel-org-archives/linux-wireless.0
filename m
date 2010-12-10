Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42761 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0LJUaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:30:07 -0500
Date: Fri, 10 Dec 2010 15:17:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/2] iwlwifi fix for 2.6.37
Message-ID: <20101210201750.GF4296@tuxdriver.com>
References: <1291918780-10882-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291918780-10882-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 09, 2010 at 10:19:38AM -0800, Wey-Yi Guy wrote:
> The original method used to parsing EEPROM Tx Power Table was hardcode and
> not forward compatible with newer devices. Fix it here to be layout agnostic
> 
> John, we split EEPROM reading patches to two stage, for .37 release,
> the existing devices will not change, only the newer devices will use
> the new EEPROM reading method; we will remove the old EEPROM reading method
> all together in separated patch for .38 release. Please let me know if this
> is ok

OK, I think this will do.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
