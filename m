Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53285 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1HXXmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:42:14 -0400
Received: by yxj19 with SMTP id 19so1271715yxj.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 16:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110824222801.GA5280@broadcom.com>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 25 Aug 2011 01:41:54 +0200
Message-ID: <CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com> (sfid-20110825_014217_821670_E699B2A8)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henry,

On 25 August 2011 00:28, Henry Ptasinski <henryp@broadcom.com> wrote:
> With the latest series of cleanup patches merged in by Greg KH, I'd like to
> once again propose moving brcm80211 out of staging and into mainline.

While I like the Idea of brcm80211 going mainline, I'd like to throw
in the suggestion that brcm80211 should be made a bcma/ssb driver
first (AFACT brcmfmac would use ssb, not bcma, therefore both).

My reasoning is that it needs to be done eventually anyway, and the
earlier this is done the less work it will be in the long term, also
it would reduce the duplicate code in bcma, ssb, and brcm80211.

Of course this is just a suggestion, and it's yours and Greg's call
whether you agree with me or not (since it's quite late in the game to
add a new TODO, and I suspect a rather big one).


Regards,
Jonas
