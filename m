Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42818 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2F0PHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:07:09 -0400
Received: by yenl2 with SMTP id l2so973588yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:07:09 -0700 (PDT)
Message-ID: <4FEB2198.7050802@lwfinger.net> (sfid-20120627_170714_726441_C2D5E1C4)
Date: Wed, 27 Jun 2012 10:07:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: Question about BCM43228 and outdated description in MAINTAINERS
References: <4FE886B3.7020202@lwfinger.net> <4FEAC62F.4000400@broadcom.com>
In-Reply-To: <4FEAC62F.4000400@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2012 03:37 AM, Arend van Spriel wrote:
> On 06/25/2012 05:41 PM, Larry Finger wrote:
>
> I noticed your email on the lockdep_init_map() function. Maybe the
> hybrid driver will be modified, but I leave that to Brett.

Obviously, the kernel will not be changed to make that routine available.

> My personal experience with ndiswrapper on 64-bit kernels is different,
> but I tend to consider ndiswrapper as a last resort. Most issues I had
> were between ndiswrapper and wpa_supplicant (when using dbus ipc).
>
>> Reverse engineering this device to be able to drive it with b43 would
>> involve a lot of effort. If your group is planning on adding it to
>> brcmsmac, then I would not undertake this project. To the fullest extent
>> that you can, please advise me regarding this matter.
>
> Our focus is currently on extending brcmfmac. We had requests for 43228
> support before, but did not start that task. Will inform internally what
> the plan is here and let you know to the fullest extent ;-)

Any help you can give will be appreciated.

>
> Under the folder drivers/net/wireless/brcm80211/ are both brcmfmac and
> brcmsmac (and shared module brcmutil). So maybe patch it like this:
>
> - BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
> + BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVERS

That will help, but perhaps you might make it

+ BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVERS (brcmsmac, brcmfmac)

This way, a search for brcmsmac or brcmfmac will succeed.

Larry
