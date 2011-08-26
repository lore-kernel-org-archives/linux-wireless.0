Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65195 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1HZTpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 15:45:14 -0400
Received: by gxk21 with SMTP id 21so3127604gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 12:45:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110826175510.GG4888@broadcom.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110826175510.GG4888@broadcom.com>
Date: Fri, 26 Aug 2011 21:45:13 +0200
Message-ID: <CACna6ryPoeFm4zZ_xGtkA5wHtbG1Z4bSk6t2tGt0nQg28aaLDQ@mail.gmail.com> (sfid-20110826_214518_604793_9C68EAFC)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 26 sierpnia 2011 19:55 użytkownik Henry Ptasinski
<henryp@broadcom.com> napisał:
> On Thu, Aug 25, 2011 at 01:55:26PM -0700, Rafał Miłecki wrote:
>> 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
>> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
>> > once again propose moving brcm80211 out of staging and into mainline.
>>
>> Henry: a simple question, please explain it to me, what brcmsmac does
>> provide that b43 doesn't?
>
> The brcmsmac driver supports the BCM4313, BCM43224, and BCM43225 chipsets with
> full performance i.e. rate vs. range comparable to what's achived with these
> chips running under other operating systems.

Out of curiosity, do you *really* already support 40 MHz channels in brcmsmac?

According to http://wireless.kernel.org/en/users/Drivers/brcm80211 you don't...

-- 
Rafał
