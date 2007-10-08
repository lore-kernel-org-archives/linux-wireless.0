Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17987 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXJHJ0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:26:42 -0400
Received: from lin01.mn-solutions.de (pD95F8393.dip0.t-ipconnect.de [217.95.131.147])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 0E79E8B21B9
	for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2007 11:05:58 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id B45EC1E002B
	for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2007 11:03:02 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: libertas and endianness
Date: Mon, 8 Oct 2007 11:06:06 +0200
References: <Pine.LNX.4.64.0710071209290.8127@anakin>
In-Reply-To: <Pine.LNX.4.64.0710071209290.8127@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710081106.06475.hs4233@mail.mn-solutions.de> (sfid-20071008_102649_107305_9F3DE19B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I.e. it tries to store 0x0100 resp. 0x0200 into keytype[i],
> which is is u8.
>
> Gr{oetje,eeting}s,

Dan Williams partially fixed this on 2nd August. Seems that 
libertas patches needs ages to trickle upwards.

The patch is buried in the libertas-2.6 tree, in the 
branch "libertas". See here:

http://git.infradead.org/?p=libertas-2.6.git;a=commitdiff;h=1bf710a1f1bd816897be3b0441d3c916ea1b9ab9



However, in my next mail I'm attaching a cosmetic change for 
this. There's no need to define a constant for an u8 as 0x0001
and 0x0002 ...
