Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2242 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1IUVoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 17:44:23 -0400
Date: Wed, 21 Sep 2011 17:43:45 -0400
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Simeon Nifos <archwndas@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: deactivating one of the two wireless connections
Message-ID: <20110921174345.4411d098@mj> (sfid-20110921_234426_568975_B917A496)
In-Reply-To: <4E73FC9A.8090901@lwfinger.net>
References: <CAL1uj0zX5gGHkQny7fE3xrVm9HgP3PvC+ff2g7sunzNvXzgu=g@mail.gmail.com>
	<4E73FC9A.8090901@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Sep 2011 20:49:14 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Downing the interface is a perfectly good solution. If you want to
> minimize the power usage, you can unload the driver for the built-in
> wireless adapter using "modprobe -r" to disable it. If you never want
> to use it, then blacklist that driver.

It's also possible to mark the device as unmanaged:
http://live.gnome.org/NetworkManager/SystemSettings

That's a good solution if the interface needs to be used occasionally
for things like sniffing or driver testing.

It would be a great if the future versions of NetworkManager allowed
users to select (in GUI) which interfaces are used.  Using all possible
interfaces in not always the best solution.

-- 
Regards,
Pavel Roskin
