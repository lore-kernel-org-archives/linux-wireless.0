Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:45317 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXC2SNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 14:13:37 -0400
Subject: Re: [PATCH] bcm43xx: Change initialization for 2050 radios
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <460C0157.5030404@lwfinger.net>
References: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net>
	 <1175188955.3122.42.camel@pmac.infradead.org>
	 <460BFDF0.9010401@lwfinger.net>
	 <1175191382.3122.44.camel@pmac.infradead.org>
	 <460C0157.5030404@lwfinger.net>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 19:13:33 +0100
Message-Id: <1175192013.3122.47.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-29 at 13:11 -0500, Larry Finger wrote:
> OK, you are measuring receive speed, which is nearly independent of
> Bit Rate. Do you have access to any other host on your LAN that could
> be an Iperf server, or that is an NFS server? 

That can be done. Need to get Fedora PS3 kernel working properly first
though...

-- 
dwmw2

