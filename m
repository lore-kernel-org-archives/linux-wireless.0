Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55553 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3GSTbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 15:31:24 -0400
Message-ID: <51E99408.2040106@suse.cz> (sfid-20130719_213147_346253_56F9FEAF)
Date: Fri, 19 Jul 2013 21:31:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211-dev-list@broadcom.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: machine freezing hard with rfkill on
References: <51E8E482.30505@suse.cz> <51E93BFA.4090808@broadcom.com>
In-Reply-To: <51E93BFA.4090808@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2013 03:15 PM, Arend van Spriel wrote:
> On 07/19/13 09:02, Jiri Slaby wrote:
>> Hi,
>>
>> our users report [1] that their machines freeze hard when they have
>> rfkill turned on and try to run wpa_supplicant or enable network
>> otherwise. This is with BCM43225 over PCI chip.
>>
>> Any ideas what that could be or how to fix this?
>>
>> [1] https://bugzilla.novell.com/show_bug.cgi?id=787649
>>
>> thanks,
> 
> Hi Jiri,
> 
> Looking in the bug report it seems to be on 3.4 kernel. The commit below
> is done later.

Hi, sorry that I missed this (I thought it was with 3.10) and for the
noise. Thanks for the hint anyway.

-- 
js
suse labs
