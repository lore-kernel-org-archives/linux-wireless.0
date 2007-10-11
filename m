Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8411 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXJKNQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 09:16:25 -0400
Received: from lin01.mn-solutions.de (pD95F89A3.dip0.t-ipconnect.de [217.95.137.163])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 9E8735E4110
	for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 15:16:24 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id C2DB31E002B
	for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 15:13:27 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Patch for Kernel and Ath5k
Date: Thu, 11 Oct 2007 15:16:44 +0200
References: <feieb9$nvg$1@sea.gmane.org> <43e72e890710101455k311c7de4x203d466bdbe73c97@mail.gmail.com> <470DFF7A.2090600@gmx.de>
In-Reply-To: <470DFF7A.2090600@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710111516.44663.hs4233@mail.mn-solutions.de> (sfid-20071011_141631_823303_CB516E98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I do got this,
> feld-bertlap:/usr/src/wireless-2.6# git-branch
>    at76
>    ath5k
>    everything
>    mac80211-attic
>    mac80211-dungeon
> * master
>    master-davem
>    merged-upstream
>    mm-master
>    origin
>    pending-stable
>    ssb-drivers
>    upstream-davem
>    zd1211rw-mac80211

Shouldn't you be on "everything" ?

I'm using:

rm -rf wireless-2.6
git clone --reference /usr/src/linux-git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
cd wireless-2.6
git checkout -b everything origin/everything
