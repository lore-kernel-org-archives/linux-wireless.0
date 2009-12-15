Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:61660 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZLOPIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 10:08:15 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Tue, 15 Dec 2009 16:06:46 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>
References: <20091022133043.185554096@mail.mn-solutions.de> <200912151544.00402.hs4233@mail.mn-solutions.de> <1260888730.10356.9.camel@johannes.local>
In-Reply-To: <1260888730.10356.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912151606.46549.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'd rather have new mesh commands. Right now, mesh
> joining/leaving is implicit with interface up/down after you
> set mesh parameters, but that's not very flexible.

The mesh of Libertas' seems to be very different from "other" 
meshes, do you really want new nl80211 commands that seems 
almost proprietary?

For example, "iw dev wlan0 set mesh_param" gives me lots of 
parameters, but none of them is a SSID. And many of those 
parameters don't seem to have an equivalent of Libertas' mesh.

-- 
http://www.holgerschurig.de
