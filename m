Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60099 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1FBAIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 20:08:50 -0400
Received: by iwn34 with SMTP id 34so263420iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 17:08:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-35-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-35-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 10:08:30 +1000
Message-ID: <BANLkTimGZiOaSmAJ7xeH+=0LK2+Rqit3zw@mail.gmail.com> (sfid-20110602_020854_003299_57CDAB33)
Subject: Re: [PATCH 35/83] staging: brcm80211: moved header files to more
 specific directory
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> Code cleanup. Header files only used by the softmac were moved to the
> brcmsmac dir, same approach for fullmac header files.
>
> Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>

Again, should there be some code changes associated with the header
file move or am I missing something?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
