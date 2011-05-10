Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65326 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1EJEUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 00:20:45 -0400
Received: by vws1 with SMTP id 1so259211vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 21:20:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimvWnhJDSdn+fhGw=WAZDU4RPEKmg@mail.gmail.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
 <1304951590-2411-10-git-send-email-arend@broadcom.com> <BANLkTimvWnhJDSdn+fhGw=WAZDU4RPEKmg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 10 May 2011 14:20:24 +1000
Message-ID: <BANLkTi=uYY22CpRvV71LDrBJyxPcN_c4HA@mail.gmail.com> (sfid-20110510_062048_664725_AD462A2D)
Subject: Re: [PATCH 9/9] staging: brcm80211: move utility functions into new module
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, Henry Ptasinski <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the split message, I mistyped and accidentally sent my
mostly incomplete message.

On Tue, May 10, 2011 at 14:18, Julian Calaby <julian.calaby@gmail.com> wrote:
> obj-$(CONFIG_BRCMWLUTIL)

I meant:

obj-$(CONFIG_BRCMWLUTIL) += util/

> The LIB80211 symbol used by the Intel 2x00 (old non-mac80211) wireless
> drivers uses similar trickery to ensure that everything is built
> properly.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
