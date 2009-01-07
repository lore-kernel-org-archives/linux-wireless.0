Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:55162 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZAGIib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 03:38:31 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libertas: if_spi, driver for libertas GSPI devices
Date: Wed, 7 Jan 2009 09:38:23 +0100
Cc: Colin McCabe <colin@cozybit.com>, libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>
References: <1230951623-26998-1-git-send-email-colin@cozybit.com> <1230951623-26998-3-git-send-email-colin@cozybit.com> <1230951623-26998-4-git-send-email-colin@cozybit.com>
In-Reply-To: <1230951623-26998-4-git-send-email-colin@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901070938.23256.hs4233@mail.mn-solutions.de> (sfid-20090107_093835_211063_A815EB2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Add initial support for libertas devices using a GSPI
> interface.  This has been tested with the 8686.  At this time,
> as far as we know, GSPI firmware for this device is not
> publicly distributable, but we expect this to change.

Can you somewhere download a Windows CE driver that contains the 
firmware in it?  If yes, then you could use my 
firmware-extractor (with some little patches). I'm fine with 
patching support for GSPI into it if you send things in.

(See "fwcutter" in this tree:)

http://git.infradead.org/users/schurig/libertas-tools.git
