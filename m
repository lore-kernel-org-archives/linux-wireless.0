Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:57807 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab1INUSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 16:18:52 -0400
Received: by vwl1 with SMTP id 1so3338631vwl.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 13:18:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0C9DEF38@SJEXCHCCR02.corp.ad.broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<20110913174444.GG11772@tuxdriver.com>
	<CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com>
	<400C43189542CE41BC0A5B252FC90136BC0C9DEF38@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Wed, 14 Sep 2011 22:18:51 +0200
Message-ID: <CACna6rzK86LQ4bULMvcfTTwtDxAGtDzc8K+uGobarnkOpax17w@mail.gmail.com> (sfid-20110914_221900_585696_5D273446)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
	Francis Moreau <francis.moro@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 września 2011 11:23 użytkownik Arend Van Spriel
<arend@broadcom.com> napisał:
> For my bcma integration effort (which is already stale due to our brcmsmac cleanup) I simply took "wireless-next" bcma using meld. Was surprised that I also needed to do this for ssb as there are some include dependencies. In early bcma discussions a strong preference was given (by Michael if I am correct) to keep bcma independent from ssb at the cost of some duplication. For include files this preference might be less strong, but I still think it is a good idea to have these chip interconnect bus drivers independent from each other.

The code is independent, if some includes are not, that should be
reported & fixed.

-- 
Rafał
