Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49174 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbbE0HYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 03:24:31 -0400
Message-ID: <1432711466.2159.0.camel@sipsolutions.net> (sfid-20150527_092437_049271_6F4D51CC)
Subject: Re: [PATCH 5/6] mwifiex: use generic name 'device dump'
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Wed, 27 May 2015 09:24:26 +0200
In-Reply-To: <f92fc66de96b485dba99642987703334@SC-EXCH02.marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
	 <1432647272-5734-6-git-send-email-akarwar@marvell.com>
	 (sfid-20150526_153538_730660_141E53A3) <1432650631.5169.11.camel@sipsolutions.net>
	 <f92fc66de96b485dba99642987703334@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-27 at 07:04 +0000, Amitkumar Karwar wrote:

> Thanks for your review. We are dumping driver data as well along with
> firmware state. Hence we thought of renaming 'fw_dump' with
> 'device_dump'.
[...]
> Debugfs file name is changed because 'device_dump' will now take care
> of dumping both driver data and firmware state.

Ok, great. Just wanted to make sure you weren't pointlessly renaming it
because of the framework name :)

> Currently we are triggering the dump operation in our command timeout
> handler as well. This would help us debug possible firmware bug
> causing timeout.

Cool, yeah, it's helping us a lot for sure.

johannes

