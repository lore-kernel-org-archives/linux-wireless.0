Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9612 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXJKNXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 09:23:05 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: remove documentation about EEPROM dump
Date: Thu, 11 Oct 2007 15:23:24 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
References: <200710111153.29974.hs4233@mail.mn-solutions.de>
In-Reply-To: <200710111153.29974.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710111523.24507.hs4233@mail.mn-solutions.de> (sfid-20071011_142312_500225_F3845B2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 October 2007 11:53:29 Holger Schurig wrote:
> The driver doesn't support dumping of the EEPROM, so this
> patch removes the documentation.


Scrap this patch.

Maybe I did the ethtool command as user, not as root. Maybe I was 
too coffein free ...  Whatever it was, "ethtool -e eth1 offset 0 
length 16" works.

