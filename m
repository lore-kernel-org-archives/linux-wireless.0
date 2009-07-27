Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:48752 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZG0Oxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 10:53:51 -0400
Date: Mon, 27 Jul 2009 15:53:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tim Gardner <timg@tpi.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Fix rfkill state setting
Message-ID: <20090727145349.GA7227@srcf.ucam.org>
References: <20090727144747.E7F4EF891B@sepang.rtg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090727144747.E7F4EF891B@sepang.rtg.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 08:47:47AM -0600, Tim Gardner wrote:
> Matthew,
> 
> I think the rfkill state change logic is inverted. I've tried the original
> code on 3 different Dell models. Once 'rfkill block all' is run, then you
> can never unblock 'dell-wifi: Wireless LAN'. With this change you can get
> it unblocked, but you need to run 'rfkill unblock all' twice (which is
> likely an issue with rfkill).

Yes, there's clearly an issue of some sort here. I'll dig out a Dell and 
test this, but it looks good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
