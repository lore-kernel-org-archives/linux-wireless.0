Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:58074 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbXJaUpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 16:45:39 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1InKRW-0000PY-Ts
	for linux-wireless@vger.kernel.org; Wed, 31 Oct 2007 16:45:38 -0400
Subject: Re: InProComm IPN2120
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1193852430.11271.3.camel@localhost.localdomain>
References: <1193852430.11271.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 16:45:36 -0400
Message-Id: <1193863536.9260.11.camel@dv> (sfid-20071031_204543_192053_7263F16C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-10-31 at 13:40 -0400, Dan Williams wrote:
> I know this hardware has no existing drivers.  However, does anyone know
> anything about this chipset?  It's B-only from about 2003 or so, I
> think.

I looked at its Windows drivers.  Normally, it's not hard to find some
identifiers like "Atmel" or "HERMES" that give away the actual chipset
manufacturer.  Not in this case.  All I see are strings like:

Inprocomm, Inc.
C:\Drv_WorkSpace2\v0219_release_driver\winxp\objfre_wxp_x86\i386\ipn2120.pdb
Driver for INPROCOMM IPN2120 Wireless LAN Cards
INPROCOMM IPC2120-based 802.11b Wireless LAN Adapter

The WLAN_UI.EXE utility has something more interesting:
INPROCOMM IPC2120 CardBus/mini-PCI Evaluation Board

It may be a good indication that Inprocomm developed the card itself.
Amusingly, the utilities also include following strings:

juji is so cool!
/I'm a engineer :p

-- 
Regards,
Pavel Roskin

