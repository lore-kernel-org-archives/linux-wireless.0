Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:50459 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbXHAWbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 18:31:42 -0400
Message-ID: <46B109C8.9090704@warmcat.com>
Date: Wed, 01 Aug 2007 23:31:36 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: libertas: blows chunks on failed firmware load
References: <46AF913F.9010006@warmcat.com> <200708010900.00514.hs4233@mail.mn-solutions.de> <46B04704.3000409@warmcat.com> <200708011131.22390.hs4233@mail.mn-solutions.de>
In-Reply-To: <200708011131.22390.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
>> Sure I will try it tonight, where should I go to get it?  The
>> only trees with "libertas" in the name on git.kernel.org don't
>> seem to be the ones.
> 
> My driver is for sure in the libertas-dev tree from the OLPC 
> people. The SVN project that contains the firmware cutter also 
> contains code to checkout this tree and select the proper branch 
> in this tree.

Hi Holger -

Well it seems the libertas_cs driver supports PCMCIA only?  The device I
have is a PC Card which uses PCI semantics... at least I added the ID
11ab:1faa to if_cs.c and nothing good happened when I inserted the
module and the PC Card.

Or maybe I didn't get the idea?

-Andy
