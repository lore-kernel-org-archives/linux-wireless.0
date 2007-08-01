Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12455 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbXHAJbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 05:31:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: libertas: blows chunks on failed firmware load
Date: Wed, 1 Aug 2007 11:31:22 +0200
Cc: Andy Green <andy@warmcat.com>
References: <46AF913F.9010006@warmcat.com> <200708010900.00514.hs4233@mail.mn-solutions.de> <46B04704.3000409@warmcat.com>
In-Reply-To: <46B04704.3000409@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708011131.22390.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sure I will try it tonight, where should I go to get it?  The
> only trees with "libertas" in the name on git.kernel.org don't
> seem to be the ones.

My driver is for sure in the libertas-dev tree from the OLPC 
people. The SVN project that contains the firmware cutter also 
contains code to checkout this tree and select the proper branch 
in this tree.


Basically, you do

git clone --reference XXXX git://git.infradead.org/libertas-2.6
cd libertas-2.6
git branch libertas-cf
git checkout libertas-cf
git pull origin libertas



However, I've "Signed-Up" this driver and asked Dan to forward it 
into wireless-dev. He hasn't done this yet :-(

If anyone want's to review the patch (in addition to what people 
did on the libertas-dev mailing list), here's an URL:

http://git.infradead.org/?p=libertas-2.6.git;a=commitdiff;h=9e25bb4c6ed9430e166b69f9f91bfccd96f0869d
