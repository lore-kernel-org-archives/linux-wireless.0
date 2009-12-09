Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:46714 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbZLISXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 13:23:02 -0500
Received: by iwn1 with SMTP id 1so4762256iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 10:23:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd145f7d0912091013o702d1ee2ueb41a97ae43a0f27@mail.gmail.com>
References: <fd145f7d0912082203l1d7ebc50j291cc36dd65a4408@mail.gmail.com>
	<43e72e890912090918m55d2816co9b04065e91e4d4f1@mail.gmail.com>
	<fd145f7d0912091013o702d1ee2ueb41a97ae43a0f27@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Dec 2009 10:22:45 -0800
Message-ID: <43e72e890912091022r151ec85awb1844b3ac9c08871@mail.gmail.com>
Subject: Re: WARNING at mac80211_ieee80211_rx
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 9, 2009 at 10:13 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> On Wed, Dec 9, 2009 at 9:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Tue, Dec 8, 2009 at 10:03 PM, Jeffrey Baker <jwbaker@gmail.com> wrote:
>>> My access point with an AR9220 stopped passing traffic,
>>
>> Jeffrey, thanks for your report, can you be a little more verbose here
>> and elaborate as to what you mean by this? Do you mean that you stop
>> hostapd or that it hostapd is still running and that somehow you
>> notice it stops sending data between its associated STAs?
>
> Yes, hostapd was still running, however stations were unable to pass
> traffic.  Actually the AP also stopped sending beacons I think,
> because the AP no longer appeared in scans.  Restarting hostapd had no
> effect.  I rebooted the machine.

Well something told mac80211 it was stopped, so curious if you can
provide more logs, both from hostapd and the kernel. Are you using git
version of hostapd?

  Luis
