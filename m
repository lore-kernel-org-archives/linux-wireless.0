Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19720 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760586AbYCSTx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:28 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: store rssi as an int
Date: Wed, 19 Mar 2008 17:07:17 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803181515.15584.hs4233@mail.mn-solutions.de> <200803191620.18554.hs4233@mail.mn-solutions.de> <1205941183.4169.26.camel@localhost.localdomain>
In-Reply-To: <1205941183.4169.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803191707.17168.hs4233@mail.mn-solutions.de> (sfid-20080319_195443_912006_3DE05132)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I still don't want an int used for a value that should never
> be unsigned...

okay, "unsigned int" then :-)   I'm just glad that "long" was as
signedness as "int" ...

I'm just making a "take" for this.
