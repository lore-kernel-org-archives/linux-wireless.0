Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1FDAvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 20:51:53 -0400
Received: by iyb14 with SMTP id 14so1781968iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 17:51:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE90DCE.6060207@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com> <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 4 Jun 2011 10:51:32 +1000
Message-ID: <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com> (sfid-20110604_025200_848127_C8BE3EFD)
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t with
 struct si_pub
To: Roland Vossen <rvossen@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 4, 2011 at 02:37, Roland Vossen <rvossen@broadcom.com> wrote:
> Hello Julian,
>
> the structure definition itself is already in a header file (aiutils.h).
> Probably you are referring to the forward declaration used in the patch?

Exactly, it probably shouldn't be here as the header file that
includes the structure should arguably already be included.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
