Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:45356 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751354Ab2BQPsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 10:48:12 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 01833-05 for <linux-wireless@vger.kernel.org>;
 Fri, 17 Feb 2012 15:48:08 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] Cleaning up code formatting errors in net/wireless pointed out by checkpatch.
Date: Fri, 17 Feb 2012 15:47:36 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E75@saturn3.aculab.com> (sfid-20120217_164828_446788_3620874F)
In-Reply-To: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Luis Felipe Strano Moraes" <lfelipe@profusion.mobi>,
	<linville@tuxdriver.com>
Cc: <johannes@sipsolutions.net>, <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> These are mostly minor changes and they are being sent as one 
> patch only in order to cause the smallest amount of disruption.

A lot of these changes don't seem to match what I thought the
linux kernel code style is.

eg:
>  void cfg80211_bss_age(struct cfg80211_registered_device *dev,
> -                      unsigned long age_secs);
> +		      unsigned long age_secs);
Args no longer lined up.

> -		pos = (u8 *) & hdr->addr4;
> +		pos = (u8 *) &hdr->addr4;
no space after cast?

> -	p1 = (u8*)(ht_capa);
> +	p1 = (u8 *)(ht_capa);
Still extra ().

I'm also not sure (personally) this sort of churn is useful.

	David


