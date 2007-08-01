Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18048 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXHALPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:15:17 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: libertas: blows chunks on failed firmware load
Date: Wed, 1 Aug 2007 13:15:10 +0200
Cc: Dan Williams <dcbw@redhat.com>, Andy Green <andy@warmcat.com>
References: <46AF913F.9010006@warmcat.com> <46B01F86.5050406@warmcat.com> <1185966204.29690.2.camel@xo-13-A4-25.localdomain>
In-Reply-To: <1185966204.29690.2.camel@xo-13-A4-25.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708011315.10439.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah, I'm wondering whether we should change that...  I don't
> know what the policy on changing driver names is though, but
> given that the driver isn't extensively used yet, we may be
> able to.

I'd say

libertas_cs     for card-services cards (CF Cards, PCMCIA etc)
libertas_usb    for USB cards
libertas_sdio   for SDIO based cards

That makes the names orthogonal :-)
