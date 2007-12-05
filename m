Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5580 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXLEIkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 03:40:24 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 3] libertas: implement new scanning logic
Date: Wed, 5 Dec 2007 09:40:41 +0100
Cc: linux-wireless@vger.kernel.org
References: <200712042136.45610.h.schurig@mn-solutions.de>
In-Reply-To: <200712042136.45610.h.schurig@mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712050940.41760.hs4233@mail.mn-solutions.de> (sfid-20071205_084027_673987_8A540093)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh, somehow the "take 2" patch to dev.h (which changed
last_scanned_channel from u8 to int) was missing here.

As I'm using last_scanned_channel == -1 as a marker, u8 is a
nono. New patch follows ...
