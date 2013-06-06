Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61987 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951Ab3FFMGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 08:06:15 -0400
Received: from mailout-de.gmx.net ([10.1.76.29]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LpiUy-1U8jpL3kGM-00fV4b for
 <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 14:06:13 +0200
Message-ID: <51B07B33.2060207@rempel-privat.de> (sfid-20130606_140620_564950_D605182B)
Date: Thu, 06 Jun 2013 14:06:11 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Marc Kleine-Budde <mkl@blackshift.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
References: <51ADBC01.6090202@blackshift.org> <1370371064-6903-1-git-send-email-linux@rempel-privat.de> <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com> <51AF4AA7.6050005@blackshift.org> <51AF4F35.50503@rempel-privat.de> <51AF6F5D.5020400@rempel-privat.de> <CAGXE3d-kg7k=R81mKcqMfM9FFBDn0A9RNYmuTdQHXRUX37QhsA@mail.gmail.com>
In-Reply-To: <CAGXE3d-kg7k=R81mKcqMfM9FFBDn0A9RNYmuTdQHXRUX37QhsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.06.2013 13:48, schrieb Helmut Schaa:
> On Wed, Jun 5, 2013 at 7:03 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> I was running two stream netperf test for 2 hours without visible
>> regressions.
>
> With or without your pskb_expand_head patch applied?
>
> Thanks,
> Helmut
>

whithout my patch, on to of wireless-testing master git. But i didn't 
had this problem before. So, may be this scenario was not used by me.
Shouldn't we actually have this check from my patch, to avoid other oopses?

-- 
Regards,
Oleksij
