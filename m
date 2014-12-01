Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46125 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaLAByn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 20:54:43 -0500
Date: Sun, 30 Nov 2014 20:54:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: firmware updates for Intel Wireless devices
 3160/7260/7265
Message-ID: <20141201015440.GB2930@merlin.infradead.org> (sfid-20141201_025447_131065_4921BBD4)
References: <54723F1B.4030509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54723F1B.4030509@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 23, 2014 at 10:10:03PM +0200, Emmanuel Grumbach wrote:
> Hello,
> 
> Intel officially released a new spin of the -9 version of the firmware for devices 3160, 7260 and 7265.
> This release had been announced a while ago, but the linux-firmware.git's maintainers didn't pick it up.
> This is a new pull request with almost the exact same -9 version - it has one more bug fix.
> Version: 25.228.9.0.
> 
> We also release new version (-10) of the firmware for the same devices. This firmware includes new features
> such as TDLS, Channel switch and others.
> Version: 23.10.10.0.
> 
> Please pull...
> 
> The following changes since commit 0e5f63771d0df6d7859f7c4100a74d737c62ac88:
> 
>   linux-firmware: Add firmware patch for Intel Bluetooth 7265 ROM-spin(D0) (2014-10-09 11:59:44 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.git master
> 
> for you to fetch changes up to 064309720ed861dde985c39cdc1a34e7bcf93cc9:
> 
>   iwlwifi: add new firmware for 3160 / 7260 / 7265 / 7265D (2014-11-21 11:11:06 +0200)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (2):
>       iwlwifi: update firmware for 3160 / 7260 / 7265
>       iwlwifi: add new firmware for 3160 / 7260 / 7265 / 7265D
> 

pulled, thanks very much Emmanuel.

regards, Kyle
