Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62297 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1EFRbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 13:31:32 -0400
Received: by pvg12 with SMTP id 12so1517300pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 10:31:31 -0700 (PDT)
Message-ID: <4DC4306F.20104@lwfinger.net> (sfid-20110506_193135_794436_29E8C830)
Date: Fri, 06 May 2011 12:31:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tom Horsley <horsley1953@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8192cu AP mode?
References: <20110506081356.08ac93a8@tomh>	<4DC40CEB.5010107@lwfinger.net> <20110506131612.7a6d40cb@tomh>
In-Reply-To: <20110506131612.7a6d40cb@tomh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 12:16 PM, Tom Horsley wrote:
> On Fri, 06 May 2011 09:59:55 -0500
> Larry Finger wrote:
>
>> If not, you can always get the compat-wireless
>> sources from http://wireless.kernel.org/en/users/Download.
>
> Well, I worked around the compile errors by reversing the
> patch that inserted the kfree_rcu calls, but now when I try
> to load the modules I get this:
>
> [root@tomh ~]# modprobe rtl8192cu
> WARNING: Error inserting rfkill (/lib/modules/2.6.35.12-90.fc14.x86_64/kernel/net/rfkill/rfkill.ko): Invalid module format
> WARNING: Error inserting cfg80211 (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/net/wireless/cfg80211.ko): Invalid module format
> WARNING: Error inserting mac80211 (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/net/mac80211/mac80211.ko): Invalid module format
> WARNING: Error inserting rtlwifi (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/drivers/net/wireless/rtlwifi/rtlwifi.ko): Invalid module format
> WARNING: Error inserting rtl8192c_common (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko): Invalid module format
> FATAL: Error inserting rtl8192cu (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko): Invalid module format
>
> I guess 2.6.35 is just too old or something.

What does the output of dmesg say?

If could be as simple as your compiler is a different version.

Larry
