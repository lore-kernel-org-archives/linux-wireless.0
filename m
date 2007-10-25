Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22834 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbXJYIhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 04:37:54 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Date: Thu, 25 Oct 2007 10:37:49 +0200
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <1192466593.15225.28.camel@localhost.localdomain> <1193073620.4325.7.camel@localhost.localdomain>
In-Reply-To: <1193073620.4325.7.camel@localhost.localdomain>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710251037.50057.hs4233@mail.mn-solutions.de> (sfid-20071025_093758_651362_148A5A8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I've put both patches that Dan acknowledged with

> I ran the driver for a while and nothing appears to have
> regressed horribly from light testing a few large transfers. 
> Seems OK to push into 2.6.25 to me.

and

> > In passing, rename the functions to libertas_XXX.
> > 
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>
> Acked-by: Dan Williams <dcbw@redhat.com>

onto

  http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=summary

or

  git://git.infradead.org/users/schurig/libertas-cleanup.git


(The rename patch is so huge). Please apply.
