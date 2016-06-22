Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37158 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcFVTHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 15:07:16 -0400
Received: by mail-wm0-f51.google.com with SMTP id a66so18977406wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 12:07:15 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
To: Ismael Luceno <ismael@iodev.co.uk>
References: <20160621001841.5383-1-ismael@iodev.co.uk>
 <57698F43.3050303@broadcom.com> <20160622183622.uo5avhsjzmnn6jgf@pirotess>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <576AE1DC.7050203@broadcom.com> (sfid-20160622_210721_651773_CCD52336)
Date: Wed, 22 Jun 2016 21:07:08 +0200
MIME-Version: 1.0
In-Reply-To: <20160622183622.uo5avhsjzmnn6jgf@pirotess>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-06-16 20:36, Ismael Luceno wrote:
> On 21/Jun/2016 21:02, Arend van Spriel wrote:
>> On 21-06-16 02:18, Ismael Luceno wrote:
>>> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
>>
>> A bit more description would be nice. I am actually wondering why you
>> would be adding this. If I am not mistaken the AE1200 can not be handled
>> by brcmfmac. Otherwise I am interested in a kernel log showing the
>> device probe sequence with brcmfmac loaded with parameter debug=0x1416.
> 
> Log attached.
> 
> I was surprised it works without any tweaking.

Nice. What kernel version are you running on. Can you also dump a
debugfs file, ie. /sys/kernel/debug/brcmfmac/*/revinfo. I want to know
what chip id and revision is reported. I have tried an AE1200 in the
past, but it had a chip revision that had insufficient memory to run
fullmac firmware. Is there FCC registration number on it?

Regards,
Arend

> There's quite a lot of unhelpful noise about those adapters, but not
> much actual information, I couldn't find anything about those that
> supposedly don't work, so I have no idea if it's just a different
> firmware version or what did change (if anything).
> 
