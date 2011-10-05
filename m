Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53496 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab1JEPoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 11:44:55 -0400
Received: by yxl31 with SMTP id 31so1699371yxl.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 08:44:55 -0700 (PDT)
Message-ID: <4E8C7B72.8070106@lwfinger.net> (sfid-20111005_174458_921364_3E5EF610)
Date: Wed, 05 Oct 2011 10:44:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend Van Spriel <arend@broadcom.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Alwin Beukers <alwin@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: [PATCH v3] move brcm80211 drivers to mainline
References: <4E8C64EF.3070203@broadcom.com> <4E8C7289.50706@hauke-m.de> <400C43189542CE41BC0A5B252FC90136BC0D574E7D@SJEXCHCCR02.corp.ad.broadcom.com>
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0D574E7D@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2011 10:40 AM, Arend Van Spriel wrote:
>> From: Hauke Mehrtens [mailto:hauke@hauke-m.de]
>> Sent: woensdag 5 oktober 2011 17:07
>>
>> Hi Arend,
>>
>> Most of the things defined in
>> drivers/net/wireless/brcm80211/include/soc.h are also defined in
>> drivers/net/wireless/brcm80211/brcmsmac/aiutils.h.
>>
>> Hauke
>
> Thanks, Hauke
>
> One of the reasons we wanted to move to mainline is that bcma
> is worked on from John's repo and we want our brcmsmac driver
> to use that. The aiutils.h file is going away when we are
> using bcma.

Good to hear that patches to switch to bcma will be coming soon.

Larry

