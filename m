Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:16457 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbXERGqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 02:46:46 -0400
Received: from lin01.mn-solutions.de (pD95F9490.dip0.t-ipconnect.de [217.95.148.144])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id E61415E45D5
	for <linux-wireless@vger.kernel.org>; Fri, 18 May 2007 08:18:36 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id F00961E002B
	for <linux-wireless@vger.kernel.org>; Fri, 18 May 2007 08:18:31 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Hermes II driver
Date: Fri, 18 May 2007 08:18:28 +0200
References: <464B72F3.5090709@passys.nl>
In-Reply-To: <464B72F3.5090709@passys.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200705180818.29081.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> to the device on initialization. The orinoco driver does not
> do that. There was a working driver source on the Agere site,
> but that is for 2.4 kernels only. I found a 2.6 patch for that
> source, but it's HermesI only. The Speedtouch 110 is HermesII.

I once wrote a patch to convert an older Hermes I/II driver to 
Kernel 2.6.15. It also did this only for an older version of the 
driver, 7.18 but not 7.22. Is the patch you found for a newer 
kernel/Agere driver version?
