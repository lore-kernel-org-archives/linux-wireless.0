Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3504 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab1BQJ2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 04:28:42 -0500
Received: from mail-sj1-12.sj.broadcom.com (mail-sj1-12.sj.broadcom.com
 [10.17.16.106]) by mail-irva-13.broadcom.com (Postfix) with ESMTP id
 819EF74D03 for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011
 01:28:17 -0800 (PST)
Received: from [192.168.1.139] (unknown [10.177.241.53]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id ED84420501 for
 <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 01:28:16 -0800 (PST)
Message-ID: <4D5CEA2F.8050905@broadcom.com>
Date: Thu, 17 Feb 2011 10:28:15 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: SSB AI support code
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
 <4D56851D.7000509@hauke-m.de>
In-Reply-To: <4D56851D.7000509@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello guys,

We (Broadcom) internally discussed in what way we can get involved in 
HDN/AI support.

We offer to write a AI library module that any driver module (eg, a new 
AI bus driver, or b43, or brcm80211) can depend on. Similar to 
mac80211.ko and cfg80211.ko, the library module only offers services to 
interested driver modules, it does *not* claim any hardware itself.

This approach improves code sharing, and still offers the driver module 
implementer plenty of flexibility. The AI library module code would have 
to be distilled from brcm80211. We propose the name 'lib_ai'.

Please let me know how your thoughts.

Thanks, Roland.

