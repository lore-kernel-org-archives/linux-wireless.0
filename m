Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1518 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801Ab1JEPkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 11:40:17 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Alwin Beukers" <alwin@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>
Date: Wed, 5 Oct 2011 08:40:02 -0700
Subject: RE: [PATCH v3] move brcm80211 drivers to mainline
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0D574E7D@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20111005_174021_697186_B67737A8)
References: <4E8C64EF.3070203@broadcom.com> <4E8C7289.50706@hauke-m.de>
In-Reply-To: <4E8C7289.50706@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Hauke Mehrtens [mailto:hauke@hauke-m.de]
> Sent: woensdag 5 oktober 2011 17:07
> 
> Hi Arend,
> 
> Most of the things defined in
> drivers/net/wireless/brcm80211/include/soc.h are also defined in
> drivers/net/wireless/brcm80211/brcmsmac/aiutils.h.
> 
> Hauke

Thanks, Hauke

One of the reasons we wanted to move to mainline is that bcma
is worked on from John's repo and we want our brcmsmac driver
to use that. The aiutils.h file is going away when we are
using bcma.

Gr. AvS

