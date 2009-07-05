Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44201 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZGER3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 13:29:13 -0400
Subject: Re: [PATCH] rfkill: prep for rfkill API changes
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1246798266.4411.1.camel@johannes.local>
References: <1246798266.4411.1.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 10:29:22 -0700
Message-Id: <1246814962.12994.222.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> We've designed the /dev/rfkill API in a way that we
> can increase the event struct by adding members at
> the end, should it become necessary. To validate the
> events, userspace and the kernel need to have the
> proper event size to check for -- when reading from
> the other end they need to verify that it's at least
> version 1 of the event API, with the current struct
> size, so define a constant for that and make the
> code a little more 'future proof'.
> 
> Not that I expect that we'll have to change the event
> size any time soon, but it's better to write the code
> in a way that lends itself to extending.
> 
> Due to the current size of the event struct, the code
> is currently equivalent, but should the event struct
> ever need to be increased the new code might not need
> changing.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

patch is fine as it is. We have discussed future extensions in this area
and I don't see any problems.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


