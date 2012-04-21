Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2DUV75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 17:59:57 -0400
Message-ID: <1335045596.6516.8.camel@jlt3.sipsolutions.net> (sfid-20120421_235959_978304_5BA6D333)
Subject: Re: Missing iwlwifi firmwares ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mageia.org>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Apr 2012 23:59:56 +0200
In-Reply-To: <4F932A3D.2070701@mageia.org> (sfid-20120421_235812_903118_31B5AB43)
References: <4F932A3D.2070701@mageia.org>
	 (sfid-20120421_235812_903118_31B5AB43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-22 at 00:44 +0300, Thomas Backlund wrote:

> When reviewing our firmware packages I noticed a few missing iwlwifi
> firmwares according to kernel-3,3,1

> [...]
> firmware:       iwlwifi-6000g2a-6.ucode
> firmware:       iwlwifi-100-6.ucode
> firmware:       iwlwifi-1000-6.ucode
> [...]
> 
> Theese three are missing from:
> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary
> 
> http://intellinuxwireless.org/?n=Downloads
> 
> 
> The API 5 ucodes are awailable, but the driver expect API 6...
> 
> So..., when will they be available ?

We don't really know, but it was really just due to a bug in the driver,
it should use MODULE_FIRMWARE with the latest released rather than the
latest testing version -- there's a patch in our queue to fix that.

johannes

