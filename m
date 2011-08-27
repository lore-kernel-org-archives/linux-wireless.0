Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48701 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1H0P1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 11:27:49 -0400
Received: by pzk37 with SMTP id 37so5891676pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 08:27:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110827152144.GA10126@suse.de>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110827143513.GN3775@shale.localdomain>
	<20110827145003.GA9405@suse.de>
	<CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
	<20110827152144.GA10126@suse.de>
Date: Sat, 27 Aug 2011 17:27:48 +0200
Message-ID: <CACna6rwdUpPwE3ir=kGDoB3zeycLeLK8_JV2gJyegTQaym=A9A@mail.gmail.com> (sfid-20110827_172756_549184_972E897B)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Dan Carpenter <error27@gmail.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 27 sierpnia 2011 17:21 użytkownik Greg KH <gregkh@suse.de> napisał:
> So, as b43 was here first, it looks like brcmfmac is the only part that
> should really move out of staging, right?

Yes, I'd like to see brcmfmac improving and leaving staging. I've
offered my help to the Broadcom, but they didn't finally respond to me
about donating me with the hardware.

-- 
Rafał
