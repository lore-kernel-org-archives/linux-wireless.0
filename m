Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HTHpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 03:45:41 -0400
Subject: Re: scanning a specific ssid
From: Johannes Berg <johannes@sipsolutions.net>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimPjyiJsdgX5j+YGQC_0=9FEfeCQUFWuXgxz7Qh@mail.gmail.com>
References: <AANLkTimPjyiJsdgX5j+YGQC_0=9FEfeCQUFWuXgxz7Qh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 09:45:38 +0200
Message-ID: <1282290338.3785.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-19 at 16:25 -0400, Christopher Piggott wrote:

> Now I want to cause it to scan for a specific SSID by issuing a probe,
> but the dbus interface fi.epitest.hostap.WPASupplicant.Interface has
> only one scan method, and it does not seem to take arguments.
> (Looking at the source file ctrl_iface_dbus_handlers.c in function
> wpas_dbus_iface_scan() you can see why - it doesn't handle or even
> look at the arguments to the message).
> 
> Is there another way to accomplish this?  I notice that a number of
> dbus messages trigger a scan.  I don't really want to try to associate
> with it, but perhaps that's the only way.

You should probably just extend the dbus API to allow passing in the
information you want? But not all drivers can always support that,
afaik.

johannes

