Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:11016 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbXJJNCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 09:02:05 -0400
Received: from lin01.mn-solutions.de (pD95F87ED.dip0.t-ipconnect.de [217.95.135.237])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id D3E8E5E41BB
	for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 15:02:03 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 846E41E002B
	for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 14:59:07 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Patch for Kernel and Ath5k
Date: Wed, 10 Oct 2007 15:02:20 +0200
References: <feieb9$nvg$1@sea.gmane.org> <200710102132.21790.bruno@thinktube.com> <feih2c$21f$1@sea.gmane.org>
In-Reply-To: <feih2c$21f$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710101502.20202.hs4233@mail.mn-solutions.de> (sfid-20071010_140211_177498_3BD1B8D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Do you mean it will fetch the whole Kernel Sources, with the
> linux-wireless Sources?

Yes, it will.

If you already have a linux source tree in the form of a 
git-repository, you can speed up the cloning tremenduously by 
using "--reference". See "git clone --help" 
or "git-clone --help".
