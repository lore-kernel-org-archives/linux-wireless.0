Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13829 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYEUHH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 03:07:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Javier Cardona" <javier@cozybit.com>
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Date: Wed, 21 May 2008 09:07:21 +0200
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	carrano@laptop.org, dwmw2@infradead.org, dilinger@queued.net
References: <4832422a.20018e0a.6b37.3217@mx.google.com> <200805201007.59746.hs4233@mail.mn-solutions.de> <445f43ac0805202252v2fc8757ax5a43ddce8188ed61@mail.gmail.com>
In-Reply-To: <445f43ac0805202252v2fc8757ax5a43ddce8188ed61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805210907.21250.hs4233@mail.mn-solutions.de> (sfid-20080521_090744_878719_271D7D33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Is David's suggestion acceptable to you?

Yes, it is. For the long time, I'd like to have a kernel option. 
I'll probably make this by myself, then I can show numbers (e.g. 
if the saving is considerable). For now, go with checking 
mesh_XXX.

> The entries in the mesh_ie directory groups the non-volatile
> parameters of the mesh Information Element that is included in
> all mesh beacons.

Ahh, ok. And since ethX can't produce mesh beacons, then mesh_ie 
entry belongs then to mshX's sysfs-entry, right?
