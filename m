Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59829 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0KCLvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 07:51:15 -0400
Subject: Re: [PATCH v2] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CD14B9D.1070305@ti.com>
References: <1288505649-28733-1-git-send-email-shahar_levi@ti.com>
	 <1288772739.1164.10.camel@chilepepper>  <4CD14B9D.1070305@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 13:50:53 +0200
Message-ID: <1288785053.1164.13.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-03 at 12:46 +0100, ext Shahar Levi wrote:
> On 11/03/2010 10:25 AM, Luciano Coelho wrote:
> > I'm also getting two checkpatch warnings:
> >
> > WARNING: please, no space for starting a line,
> > 				excluding comments
> > #669: FILE: drivers/net/wireless/wl12xx/main.c:2227:
> > +       .ht_cap = WL12XX_HT_CAP,$
> This is weird. In order to find those warning i ran:
> "./scripts/checkpatch.pl 
> wl12xx-files-prefix-v2/0001-wl1271-Change-wl12xx-Files-Names.patch
> total: 0 errors, 0 warnings, 598 lines checked
> 
> wl12xx-files-prefix-v2/0001-wl1271-Change-wl12xx-Files-Names.patch has 
> no obvious style problems and is ready for submission."
> 
> On that patch it didn't find warning.
> Is there more efficient way to validate those issue?

Hmmm... This could also be our mailserver fscking up again.  If you
don't get those warnings yourself, just ignore this comment :)


-- 
Cheers,
Luca.

