Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43305 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab1CCLab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 06:30:31 -0500
Received: by wwb22 with SMTP id 22so1223097wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 03:30:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110301160316.GT18043@bicker>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
 <1298840055-5044-2-git-send-email-martinez.javier@gmail.com>
 <20110301031151.GA7620@kroah.com> <AANLkTi=zU-F=y2qn6B90F3esbNVkE6_nCOZS-dnTA4en@mail.gmail.com>
 <20110301160316.GT18043@bicker>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 3 Mar 2011 12:30:15 +0100
Message-ID: <AANLkTimbskweo7NGGLSj+O3h0kJXbugoptHN6d1DCx59@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: brcm80211: Remove unused variables and code
 clean up
To: Dan Carpenter <error27@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
	Dowan Kim <dowan@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> Do you want me to wait a few days to redo and resend it or am I doing
>> something wrong?
>
> Actually Arend has a different patch for this, that I guess fixes the
> #if 0 code instead of removing it.  Probably that's prefered.  I've
> asked him to submit it.
>
> regards,
> dan carpenter
>

Yes, fixing the #ifdef 0 instead of just removing it is far a better solution.

Thanks

-- 
-----------------------------------------
Javier Martínez Canillas
(+34) 682 39 81 69
PhD Student in High Performance Computing
Computer Architecture and Operating System Department (CAOS)
Universitat Autònoma de Barcelona
Barcelona, Spain
