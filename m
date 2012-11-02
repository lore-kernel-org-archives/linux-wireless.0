Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nk11p00mm-asmtp009.mac.com ([17.158.161.8]:51013 "EHLO
	nk11p00mm-asmtp009.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab2KBAou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 20:44:50 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Received: from [10.20.200.174]
 (p3027-ipbf5206marunouchi.tokyo.ocn.ne.jp [118.8.142.27])
 by nk11p00mm-asmtp009.mac.com
 (Oracle Communications Messaging Server 7u4-26.01(7.0.4.26.0) 64bit (built Jul
 13 2012)) with ESMTPSA id <0MCU00C594PXL160@nk11p00mm-asmtp009.mac.com> for
 linux-wireless@vger.kernel.org; Fri, 02 Nov 2012 00:44:23 +0000 (GMT)
Message-id: <50931755.9070902@mac.com> (sfid-20121102_014505_595513_A7FFDF21)
Date: Fri, 02 Nov 2012 09:44:05 +0900
From: Akira Nonaka <nonaka@mac.com>
To: linux-wireless@vger.kernel.org
Subject: Re: rtl8723e disconnect problem on the kernel 3.4.9.
References: <509200A2.9060300@mac.com> <50929F0C.5060501@lwfinger.net>
In-reply-to: <50929F0C.5060501@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Larry,

(2012/11/02 1:10), Larry Finger wrote:

> (1) What version of the vendor driver are you using?

I got the driver from below, where my PC vendor told me to go.

http://www.liteon.com/UserFiles/driver/Module/Network/WLAN/RTL/rtl_92ce_92se_92de_8723ae_linux_mac80211_0007.0809.2012.tar.gz

> (2) Are the memset errors fixed? There are a number of calls where args 2 and 3
> are reversed.

I will check the source code.

> (3) Can you build your own kernel? If so, check
> http://www'lwfinger.com/realtek_drivers/rtl8723ae_master_patch. That will patch
> a 3.4 kernel to include the driver rtl8723ae that has been submitted for
> inclusion in kernel 3.8.

I will try this patch also and get back to you.

Regards,
-- 
Akira Nonaka
