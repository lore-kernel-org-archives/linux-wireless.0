Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52281 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561Ab2J3VKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 17:10:16 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: rtlwifi: rtl8192cu: Add new USB ID
Date: Tue, 30 Oct 2012 22:10:01 +0100
Cc: Albert Pool <albertpool@solcon.nl>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org
References: <5090314E.7070703@solcon.nl> <1351629925.13356.21.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1351629925.13356.21.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201210302210.01258.chunkeey@googlemail.com> (sfid-20121030_221022_082626_3A11FFEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 30, 2012 09:45:25 PM Ben Hutchings wrote:
> On Tue, 2012-10-30 at 20:58 +0100, Albert Pool wrote:
> > This is an ISY IWL 2000. Probably a clone of Belkin F7D1102 050d:1102. 
> > Its FCC ID is the same.
> > 
> > Signed-off-by: Albert Pool <albertpool@solcon.nl>
> [...]
> 
> This is not the correct way to submit a change to stable.  See
> Documentation/stable_kernel_rules.txt
> 
Well, here's a quote from the author in the original post:
"I can't get the device to connect to my wifi, but it at least detects
networks with this patch. Probably a clone of Belkin F7D1102 050d:1102.
Its FCC ID is the same."

<http://www.spinics.net/lists/linux-wireless/msg98340.html>

Unless this device is working now, I wouldn't recommend a Cc: stable.

Regards,
	Chr
