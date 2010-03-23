Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([207.7.131.186]:43519 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0CWWUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 18:20:36 -0400
Date: Tue, 23 Mar 2010 15:13:50 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Greg KH <greg@kroah.com>
Subject: iwl6050 firmware?
Message-ID: <20100323221350.GA20509@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It's been several months since iwl6050 support was merged to mainline,

    commit e1228374d648efe451973bc5f3d1f9a8e943ec0b
    Author: Jay Sternberg <jay.e.sternberg@linux.intel.com>
    Date:   Mon Jan 19 15:30:34 2009 -0800

	iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series

and hardware is shipping,

02:00.0 Network controller: Intel Corporation WiMAX/WiFi Link 6050 Series (rev 35)

but the firmware isn't yet in linux-firmware.git nor on
intellinuxwireless.org.

Any ETA on a release?

Thanks,
-andy
