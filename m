Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61799 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab0BFRwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 12:52:41 -0500
Received: by ewy28 with SMTP id 28so1118285ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2010 09:52:39 -0800 (PST)
Message-ID: <4B6DAC5B.6050701@gmail.com>
Date: Sat, 06 Feb 2010 17:52:27 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Holger Schurig <holgerschurig@googlemail.com>
CC: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	dcbw@redhat.com
Subject: Re: [RFC 0/2] cfg80211: Retrieve missing BSS info after connect
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com> <201002061827.48913.holgerschurig@gmail.com>
In-Reply-To: <201002061827.48913.holgerschurig@gmail.com>
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
>> It sounds like the libertas cfg80211 drivers have the same problem, so I'm
>> posting them in case they're useful.
> 
> I'm not sure about that.
> 
> One thing that I'm sure of is that for the Libertas case I need to scan 
> *before* the connection takes place. The Libertas firmware doesn't roam by 
> itself, so I don't tell her an SSID like you'll tell the orinoco firmware.
> 
> Instead the libertas firmware needs a BSSID where it should connect to. If 
> you let do wpa_supplicant do the job (even for WEP), that's no problem, 
> because wpa_supplicant always scans and then connects to a specific BSSID, 
> which suits Libertas very well.

Fair enough. If I find the time to finish orinoco cfg80211, then I'll
try to keep this within the driver.


Dave.
