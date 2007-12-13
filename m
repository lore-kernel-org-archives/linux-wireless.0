Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22306 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXLMH7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:59:36 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour learning algorithm
Date: Thu, 13 Dec 2007 09:00:24 +0100
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
References: <20071209211547.2d7fca32@morte> <1197384754.4037.23.camel@johannes.berg> <1197393788.7528.5.camel@localhost>
In-Reply-To: <1197393788.7528.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712130900.25030.hs4233@mail.mn-solutions.de> (sfid-20071213_075939_591869_357FF779)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So let's go back to the original issue: Johannes, can we
> assume rate control always gets reinitialized when the number
> of rates or even the hardware mode is changed?

Make sure that at least you reinitialize rate control when you 
re-associate.
