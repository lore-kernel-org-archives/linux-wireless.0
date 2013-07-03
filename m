Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3162 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab3GCU5W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 16:57:22 -0400
Received: from [10.0.2.15] (unknown [10.177.252.108]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 90067207C0 for
 <linux-wireless@vger.kernel.org>; Wed, 3 Jul 2013 13:57:12 -0700 (PDT)
Message-ID: <51D49027.9010803@broadcom.com> (sfid-20130703_225725_898124_EAB997AB)
Date: Wed, 3 Jul 2013 22:57:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: interested in py80211?
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A common say in Linux arena is "when you have an itch, just scratch it". 
My itch is that tools like ifconfig and iw are great, but in an 
automated test environment it kind of sucks to parse output, which is 
confirmed by blurb from iw: "Do NOT screenscrape this tool, we don't 
consider its output stable.".

Ever since my first contact with Python I tend to favor it over other 
scripting alternatives so I decided to scratch my itch with that and 
another old acquaintance called SWIG. With those I went to create 
py80211. A first attempt was to have SWIG create a wrapper API directly 
exposing the libnl-3 API, but that did not feel comfortable in a 
scripting environment. So the level of abstraction is a bit higher. It 
is just in a kick-off state (eg. can only send u32 attributes), but I 
decided to push it to github anyway.

https://github.com/arend/py80211

Regards,
Arend

