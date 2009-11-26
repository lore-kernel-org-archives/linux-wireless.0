Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12828 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbZKZOMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 09:12:18 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: move more association code to assoc.c
Date: Thu, 26 Nov 2009 15:12:07 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200911261456.20476.holgerschurig@gmail.com>
In-Reply-To: <200911261456.20476.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911261512.07954.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;

Hmm, I can move this too, with cfg80211 there's no priv->secinfo.

Will post a v2 patch soon.

-- 
http://www.holgerschurig.de
