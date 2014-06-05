Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaFENXT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 09:23:19 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/1] ieee80211.h: Add definitions for 20/40 BSS Coexist Mgmt action frame
References: <1401972255-18815-1-git-send-email-Jes.Sorensen@redhat.com>
	<1401972383.4168.5.camel@jlt4.sipsolutions.net>
Date: Thu, 05 Jun 2014 15:23:14 +0200
In-Reply-To: <1401972383.4168.5.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 05 Jun 2014 14:46:23 +0200")
Message-ID: <wrfjwqcvjxrx.fsf@ultrasam.lan.trained-monkey.org> (sfid-20140605_152323_531628_4628F6A1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
>> The 8723au driver issues BSS Coexistence Mgmt Action Frames, so rather
>> keeping defines for this in a private driver header, I added it to the
>> shared ieee80211.h header.
>
> Arguably, it shouldn't, since wpa_supplicant also handles this - or is
> it offloaded in some way to the firmware?

Per our IRC discussion, I'd say lets drop this patch for now. I'll
remove the BSS Coexist packet generation from the driver instead, on the
base that these packets should be coming from wpa_s if needed.

Cheers,
Jes
