Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:37548 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932502AbXJPODi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 10:03:38 -0400
Received: from ninjamobile.local (unknown [85.102.69.93])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by uludag.org.tr (Postfix) with ESMTP id 138CA61979C0
	for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 17:03:30 +0300 (EEST)
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
To: linux-wireless@vger.kernel.org
Subject: Re: Problem with in-kernel iwl3945 driver
Date: Tue, 16 Oct 2007 17:03:51 +0300
References: <200710161317.45460.ismail@pardus.org.tr>
In-Reply-To: <200710161317.45460.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200710161703.51343.ismail@pardus.org.tr> (sfid-20071016_150340_479148_972107C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replying to myself,

Tuesday 16 October 2007 Tarihinde 13:17:45 yazm=C4=B1=C5=9Ft=C4=B1n=C4=B1=
z:
[...]
> wlan0     IEEE 802.11b  ESSID:"XXYYZZ"
                         ^^^^^^^
Looks like its in 802.11b mode instead of 802.11g.  That might be a clu=
e for=20
slowdown.

Regards,
ismail

--=20
=46aith is believing what you know isn't so -- Mark Twain
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
