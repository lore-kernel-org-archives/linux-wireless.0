Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2987 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345Ab1CCPiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:38:13 -0500
To: "Javier Martinez Canillas" <martinez.javier@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 1/2] staging: brcm80211: Add buf_size parameter to
 ampdu_action handler function
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
 <op.vrqdhre53ri7v4@arend-laptop>
 <AANLkTik2y0ULwpDXNm+GzvXw0NGRpj0gUjbdBhjcO_1z@mail.gmail.com>
Date: Thu, 3 Mar 2011 16:38:01 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vrrxpnvs3ri7v4@arend-laptop>
In-Reply-To: <AANLkTik2y0ULwpDXNm+GzvXw0NGRpj0gUjbdBhjcO_1z@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 03 Mar 2011 12:50:26 +0100, Javier Martinez Canillas  
<martinez.javier@gmail.com> wrote:

> Hi Arend,
>
> I tried to compile the driver in today linux-next (which already has
> the patch applied) and doesn't gives any warning.
>
> Please tell me if you still are having issues with it.
>
No issues. Your patch also landed in staging-next (I think) but  
net/mac80211.h in staging-next still differs from linux-next so the  
warning I mentioned will probably disappear soon.
>
> Thanks a lot.
>

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

