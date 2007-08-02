Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:42868 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbXHBGkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 02:40:43 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 4CCBA1804B256
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 07:40:42 +0100 (BST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id BC095105DB
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 06:40:49 +0000 (UTC)
Message-ID: <46B17C68.5040708@warmcat.com>
Date: Thu, 02 Aug 2007 07:40:40 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: libertas: blows chunks on failed firmware load
References: <46AF913F.9010006@warmcat.com> <200708011131.22390.hs4233@mail.mn-solutions.de> <46B109C8.9090704@warmcat.com> <200708020826.47399.hs4233@mail.mn-solutions.de>
In-Reply-To: <200708020826.47399.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> On Thursday 02 August 2007 00:31, Andy Green wrote:
>> Well it seems the libertas_cs driver supports PCMCIA only? 
> 
> Right, like libertas_cs is --- like e.g. orinoco_cs --- just for 
> for PCMCIA based designs, like CF CARD. If you have a PCI based 
> device, you'll need to write your own libertas_pci driver

Well, thanks for trying to help.

/me shoves PC Card in junk drawer

-Andy
