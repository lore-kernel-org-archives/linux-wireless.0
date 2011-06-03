Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3490 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab1FCQkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 12:40:08 -0400
Message-ID: <4DE90E5B.4070403@broadcom.com> (sfid-20110603_184017_619895_FFEDC441)
Date: Fri, 3 Jun 2011 18:39:55 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"arend Van Spriel" <arend@broadcom.com>
Subject: Re: [PATCH 71/83] staging: brcm80211: further simplified
 register access macro's
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-71-git-send-email-rvossen@broadcom.com>
 <BANLkTimQT7Hqy=_UWr1ZL127NOXgAgvgKQ@mail.gmail.com>
In-Reply-To: <BANLkTimQT7Hqy=_UWr1ZL127NOXgAgvgKQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As a next step of this cleanup, you might want to turn these into
> static inline functions instead of macros.

True, inline functions have better type safety. Arend van Spriel is 
currently looking at interfacing the macro's (cc'ed), we will keep this 
in mind.

Thanks, Roland.

