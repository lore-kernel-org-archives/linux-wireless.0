Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58251 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1CAPiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 10:38:11 -0500
Received: by wyg36 with SMTP id 36so4778990wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 07:38:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110301031151.GA7620@kroah.com>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
 <1298840055-5044-2-git-send-email-martinez.javier@gmail.com> <20110301031151.GA7620@kroah.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 1 Mar 2011 16:37:55 +0100
Message-ID: <AANLkTi=zU-F=y2qn6B90F3esbNVkE6_nCOZS-dnTA4en@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: brcm80211: Remove unused variables and code
 clean up
To: Greg KH <greg@kroah.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> ---
>>  drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c |    9 ---------
>
> This doesn't apply anymore, care to redo it and resend?
>
> thanks,

Sure Greg but I tried with today linux-next and the patch applies
cleanly. Maybe the problem are some patches that you have but haven't
reached linux-next yet.

Do you want me to wait a few days to redo and resend it or am I doing
something wrong?

Thanks

-- 
-----------------------------------------
Javier Martínez Canillas
(+34) 682 39 81 69
PhD Student in High Performance Computing
Computer Architecture and Operating System Department (CAOS)
Universitat Autònoma de Barcelona
Barcelona, Spain
