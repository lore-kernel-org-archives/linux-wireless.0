Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762664AbYARQfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 11:35:10 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: more iwlwifi merge fallout?
Date: Fri, 18 Jan 2008 08:35:09 -0800
Message-ID: <D936D925018D154694D8A362EEB08920036F28DD@orsmsx416.amr.corp.intel.com> (sfid-20080118_163531_670868_0F29C102)
In-Reply-To: <1200615744.5716.5.camel@johannes.berg>
References: <1200615744.5716.5.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 17, 2008 4:22 PM, Johannes Berg  wrote:

> Declaring
> 
> inline int iwl3945_eeprom_acquire_semaphore(...)
> 
> is a bit weird for a function that is actually declared in a header
> file and not static.

This is not merge fallout, but has been this way since the driver was
merged the first time. I do not know why it was done this way and I am
not familiar enough with gcc optimization to know the implications of
this (or what the better way should be). What do you suggest?

Thanks

Reinette
