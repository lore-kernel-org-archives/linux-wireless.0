Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:32862 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZCFTAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 14:00:22 -0500
Message-ID: <49B17320.8010000@oracle.com> (sfid-20090306_200027_226511_3656C1A5)
Date: Fri, 06 Mar 2009 11:01:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
In-Reply-To: <20090306191311.697e7b97.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell wrote:
> Hi all,
> 
> Linus' release of -rc7 seems to have stirred people up a bit ...
> 
> Changes since 20090305:


when CONFIG_RFKILL=n, ath9k/virtual.c causes:

(.text+0x224e83): undefined reference to `ath_radio_disable'
(.text+0x224e8b): undefined reference to `ath_radio_enable'



-- 
~Randy
