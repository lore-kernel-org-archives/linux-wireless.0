Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1159 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbXFLNTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 09:19:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: Please pull libertas-2.6
Date: Tue, 12 Jun 2007 15:19:09 +0200
References: <1181102122.18061.8.camel@xo-28-0B-88.localdomain> <200706120843.48517.hs4233@mail.mn-solutions.de> <1181649582.17599.4.camel@xo-28-0B-88.localdomain>
In-Reply-To: <1181649582.17599.4.camel@xo-28-0B-88.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706121519.09758.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Well; I'm going to commit that one really soon to
> libertas-2.6, but I don't think it's 2.6.22 material mainly
> because there's no code for CF cards in libertas-2.6 yet
> anyway...

Right, it's not 2.6.22 material. That's why I asked for inclusion 
in libertas-2.6 once I heard that you & Linville are 
cherry-picking bugfixes.


But I hope to be far enought so that the driver (marked 
EXPERIMENTAL) works so that I can submit it to 2.6.23.

I just fear that the merge-window for 2.6.23 opens too early for 
me :-)



BTW, my posted patch introduces one sparse-warning (forgot to 
declare a function "static"). However, sparse also found another 
variable (in join.c). So I can send you an updated version of my 
remove-fw patch to fix my own sparse warning ...  or another 
patch that fixes both warnings.
