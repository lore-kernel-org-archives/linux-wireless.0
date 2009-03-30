Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:50070 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbZC3KEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:04:20 -0400
Date: Mon, 30 Mar 2009 11:04:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330100414.GA20461@srcf.ucam.org> (sfid-20090330_120422_684574_D9A1B1C9)
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238406057.24972.23.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 11:40:57AM +0200, Johannes Berg wrote:
> TODO:
> 
>  * toshiba_acpi.c
>    -> need help, seems to abuse input polldev and report it as both
>       input and rfkill block state? at very least need info about what
>       hw actually does

I'm looking at reworking some of this today.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
