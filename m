Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25123 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXJHKBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 06:01:05 -0400
Received: from lin01.mn-solutions.de (pD95F8393.dip0.t-ipconnect.de [217.95.131.147])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 5A2525E47DF
	for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2007 12:01:04 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 158761E002B
	for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2007 11:58:08 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas link error due to gcc `smartness'
Date: Mon, 8 Oct 2007 12:01:12 +0200
References: <Pine.LNX.4.64.0710080940110.8127@anakin>
In-Reply-To: <Pine.LNX.4.64.0710080940110.8127@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710081201.12268.hs4233@mail.mn-solutions.de> (sfid-20071008_110121_897474_EB7E21B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Due to the lack of hardware, I could not test the
> functionality of this change. I was just trying to compile a
> kernel with a much enabled as possible.

I have the hardware :-)    With it, the driver still compiles and 
an

   $ echo 'ssid="BLAHFASEL"' \
     >/proc/sys/debug/libertas_wireless/eth1/setuserscan

doesn't bark and seems to produce the desired thing.

Not that I think something like userscanning is actually needed 
in real life ....  Anyway:

Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>
