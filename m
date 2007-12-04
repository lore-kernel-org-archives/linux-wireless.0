Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10842 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbXLDPyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:54:17 -0500
Received: from lin01.mn-solutions.de (pD95F94BA.dip0.t-ipconnect.de [217.95.148.186])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id E266D5E409F
	for <linux-wireless@vger.kernel.org>; Tue,  4 Dec 2007 16:54:15 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 287151E00FD
	for <linux-wireless@vger.kernel.org>; Tue,  4 Dec 2007 16:51:22 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
Date: Tue, 4 Dec 2007 16:54:31 +0100
References: <200712041140.07516.hs4233@mail.mn-solutions.de> <20071204152538.GF19911@tuxdriver.com> <1196782188.26155.49.camel@localhost.localdomain>
In-Reply-To: <1196782188.26155.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712041654.31973.hs4233@mail.mn-solutions.de> (sfid-20071204_155421_032388_6E810936)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It might mean more memory usage for these drivers because not
> all of them need all the fields in the common BSS structure. 
> It may mean slightly more CPU time used to convert the
> driver's internal BSS representation into the common BSS
> structure.

I'm mostly doing things for embedded stuff, but actually I like 
the benefits more than the drawbacks.

+1 for your whole idea.
