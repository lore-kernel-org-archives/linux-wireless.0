Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FFNgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:36:45 -0400
Message-ID: <1338989804.26346.9.camel@jlt3.sipsolutions.net> (sfid-20120606_153648_683824_0F0BB512)
Subject: Re: [PATCH 00/29] iwlwifi updates for 3.6
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jun 2012 15:36:44 +0200
In-Reply-To: <1338989268.26346.7.camel@jlt3.sipsolutions.net> (sfid-20120606_152755_189002_11E6AA00)
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120606_152231_979720_A2082B64) <1338989268.26346.7.camel@jlt3.sipsolutions.net>
	 (sfid-20120606_152755_189002_11E6AA00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 15:27 +0200, Johannes Berg wrote:
> Hi John,
> 
> The following changes since commit fdbfff73408f99799724f583cbc2a0ce3263c6a7:
> 
>   net/wireless: ipw2200: introduce ipw_read_eeprom function (2012-06-05 17:15:49 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to b1abedada3fd0aa100723aa9b60b7e31c17945cb:
> 
>   iwlwifi: remove extern opmode ops declarations (2012-06-06 13:26:00 +0200)
> 
> 
> 
> Unfortunately, conflict resolution between this and wireless.git is
> tricky -- not the conflicts, but what doesn't conflict:
> 	.eeprom_params = &iwl6000_eeprom_params,
> needs to be added to IWL_DEVICE_6035 in pcie/6000.c. How do you want to
> handle that?

This is my resolution: http://p.sipsolutions.net/4900c9143e20ef10.txt
(in 3-way format)

johannes

