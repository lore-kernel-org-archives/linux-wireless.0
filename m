Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51115 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYJVHz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 03:55:29 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@linux.intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224660449.28639.22.camel@johannes.berg>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 09:56:25 +0200
Message-Id: <1224662185.9386.131.camel@californication> (sfid-20081022_095541_874298_41127E9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I do not believe our request is unreasonable. If a user runs a new
> > kernel the log will print a message that the firmware is incorrect ...
> > all the user needs to do is go to
> > http://intellinuxwireless.org/?n=Downloads and download the latest
> > firmware.
> 
> And that exactly _is_ a problem, the user may be relying on wireless
> connectivity. And they won't know up-front they need new firmware. Since
> firmware is loaded from userspace, you're breaking userspace/kernel ABI,
> it's pretty simple really.

I talked to David Woodhouse and we plan to add a big warning to
modules_install when MODULE_FIRMWARE is not present on the filesystem.

> I really don't know why we let you get away with this and bitch
> endlessly when b43 does such a change, to the point where we finally
> cave in and support both versions. Why should a community-supported
> driver be held to higher standards?

If in any way possible, we should support both versions of the firmware.

Regards

Marcel


