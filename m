Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19625 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbYCSTxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: convert RSSI to a direct command
Date: Wed, 19 Mar 2008 17:36:21 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803181342.42704.hs4233@mail.mn-solutions.de> <1205937089.26119.20.camel@localhost.localdomain>
In-Reply-To: <1205937089.26119.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803191736.22042.hs4233@mail.mn-solutions.de> (sfid-20080319_195437_101868_241330DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> We do need a qual.level for adhoc though.  Unfortunately,
> there's no way for userspace to know that the adhoc BSS the
> card is associated with is created by the card, or if the card
> just joined the BSS.  We should be reporting 100% signal
> strength there or something.

Take 2 of the patch does this now.
