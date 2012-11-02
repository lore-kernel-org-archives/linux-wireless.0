Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nk11p00mm-asmtp002.mac.com ([17.158.161.1]:40901 "EHLO
	nk11p00mm-asmtp002.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760505Ab2KBJoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 05:44:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Received: from [10.20.200.174]
 (p3027-ipbf5206marunouchi.tokyo.ocn.ne.jp [118.8.142.27])
 by nk11p00mm-asmtp002.mac.com
 (Oracle Communications Messaging Server 7u4-26.01(7.0.4.26.0) 64bit (built Jul
 13 2012)) with ESMTPSA id <0MCU00EAHTPVK280@nk11p00mm-asmtp002.mac.com> for
 linux-wireless@vger.kernel.org; Fri, 02 Nov 2012 09:44:21 +0000 (GMT)
Message-id: <509395E1.5010609@mac.com> (sfid-20121102_104438_985326_119AE966)
Date: Fri, 02 Nov 2012 18:44:01 +0900
From: Akira Nonaka <nonaka@mac.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8723e disconnect problem on the kernel 3.4.9.
References: <509200A2.9060300@mac.com> <50929F0C.5060501@lwfinger.net>
 <50931EEC.9040606@mac.com> <509325BA.2060807@lwfinger.net>
In-reply-to: <509325BA.2060807@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

I applied your patch against the compat-wireless-2012-10-03.tar.bz2
(http://linuxwireless.org/download/compat-wireless-2.6/)
and it is now working stably on the kernel 3.4.9.

Thank you very much!!!

(2012/11/02 10:45), Larry Finger wrote:
> Those are all fixed in my patch. The driver that you are using was my starting
> point for the one that will be included in the kernel. My experience is that the
> connections that I get are extremely stable, particularly for a new driver.
> 
> Larry


-- 
Akira Nonaka
