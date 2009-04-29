Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:44476 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZD2PVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 11:21:15 -0400
Message-ID: <49F870A5.20809@oracle.com> (sfid-20090429_172122_937535_D4A7E199)
Date: Wed, 29 Apr 2009 08:22:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for April 29 (wireless/ath build failure)
References: <20090429173916.1a608076.sfr@canb.auug.org.au>
In-Reply-To: <20090429173916.1a608076.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


drivers/net/wireless/ath/ar9170/usb.c:692: error: 'struct usb_device' has no member named 'reset_resume'

when CONFIG_PM=n.


-- 
~Randy
