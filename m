Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20202 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbXJOObz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:31:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Date: Mon, 15 Oct 2007 16:28:43 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <200710150918.02708.hs4233@mail.mn-solutions.de> <1192457588.12009.5.camel@localhost.localdomain>
In-Reply-To: <1192457588.12009.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710151628.43425.hs4233@mail.mn-solutions.de> (sfid-20071015_153159_111541_784FCF94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan !

> I don't really care.  You've already done the work for 'lbs'
> so that's fine by me.

Yeah, but doing something like

   perl -pi -e 's:lbs_:lts_:g' XXXX.patch

would be easy enought.



Did already look at

http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=commitdiff;h=aff223229493c7c43c8acedc728cdb312f82f3f9

????   Please review :-)
