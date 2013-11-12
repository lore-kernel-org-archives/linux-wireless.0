Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KLQey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 11:34:54 -0500
Message-ID: <1384274088.14301.8.camel@jlt4.sipsolutions.net> (sfid-20131112_173457_181802_810E26EA)
Subject: Re: [PATCH] iw: add support for 5 and 10 MHz channels in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 12 Nov 2013 17:34:48 +0100
In-Reply-To: <1384273978-11510-1-git-send-email-sw@simonwunderlich.de>
References: <1384273978-11510-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 17:32 +0100, Simon Wunderlich wrote:
> 5/10 MHz requires to send the frequency information as chandef instead
> of the the old channel type, this change is included here as well.

I think you need to keep the channel type to stay compatible with old
kernels.

johannes

