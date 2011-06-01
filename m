Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50423 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab1FAXol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 19:44:41 -0400
Received: by iwn34 with SMTP id 34so251005iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 16:44:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-38-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-38-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 09:44:20 +1000
Message-ID: <BANLkTikxas2f7d1mNU-usy-BPWVP+XwLFA@mail.gmail.com> (sfid-20110602_014448_303585_DD670519)
Subject: Re: [PATCH 38/83] staging: brcm80211: move PCI related header files
 to appropriate driver folder
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> From: Arend van Spriel <arend@broadcom.com>
>
> The include file pcicfg.h is now only required by brcmfmac driver. Similarly,
> nicpci.h is only required by brcmsmac driver. These header files have been
> moved to the appropriate driver specific folder.
>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Reviewed-by: Roland Vossen <rvossen@broadcom.com>

Should there be any code changes associated with this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
