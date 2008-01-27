Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:63009 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbYA0TLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 14:11:11 -0500
Subject: Re: [PATCH 10/14] [rndis_host] Add early_init function pointer to
	'struct rndis_data'.
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: David Brownell <david-b@pacbell.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bjd@jooz.net
In-Reply-To: <200801270814.43760.david-b@pacbell.net>
References: <20080125225032.11716.77713.stgit@fate.lan>
	 <20080125225128.11716.59998.stgit@fate.lan>
	 <200801270814.43760.david-b@pacbell.net>
Content-Type: text/plain
Date: Sun, 27 Jan 2008 21:11:03 +0200
Message-Id: <1201461063.3663.24.camel@localhost> (sfid-20080127_191120_210098_F86D3D66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-01-27 at 08:14 -0800, David Brownell wrote:
> On Friday 25 January 2008, Jussi Kivilinna wrote:
> > Function pointer is for 'subminidrivers' that need to do work on device 
> > right after minidriver has initialized hardware.
> > 
> > For example, rndis_wlan setting device specific configuration parameters
> > with OID_GEN_RNDIS_CONFIG_PARAMETER right after rndis_host has 
> > initialized hardware with RNDIS_INIT.
> > 
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> ... though I'm not sure I'd coin a term like "subminidriver".  ;)

Hm.. sure there could have been better ways of explaining that but with
my inadequate english skills that's what came out first :)

