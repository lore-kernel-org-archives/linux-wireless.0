Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21906 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXGILKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 07:10:55 -0400
Received: from lin01.mn-solutions.de (pD95F8A4E.dip0.t-ipconnect.de [217.95.138.78])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 2DE658B1545
	for <linux-wireless@vger.kernel.org>; Mon,  9 Jul 2007 13:10:54 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 6F09F1E002B
	for <linux-wireless@vger.kernel.org>; Mon,  9 Jul 2007 13:10:49 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Date: Mon, 9 Jul 2007 13:10:48 +0200
References: <20070709193744.D021.MOKUNO@sm.sony.co.jp>
In-Reply-To: <20070709193744.D021.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707091310.49149.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch removes some duplicated wireless ioctl entries in
> the array 'struct ioctl_trans ioctl_start[]' of
> fs/compat_ioctl.c
> -COMPATIBLE_IOCTL(SIOCSIWSCAN)
>  COMPATIBLE_IOCTL(SIOCSIWRATE)
>  COMPATIBLE_IOCTL(SIOCGIWRATE)

Maybe you remove the double COMPATIBLE_IOCTL(SIOCGIWRATE) as 
well?
