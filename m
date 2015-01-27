Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:37354 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbA0QyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 11:54:00 -0500
Received: by mail-oi0-f45.google.com with SMTP id g201so13272101oib.4
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 08:53:59 -0800 (PST)
Message-ID: <54C7C2A6.7040904@lwfinger.net> (sfid-20150127_175403_394812_4A6AA081)
Date: Tue, 27 Jan 2015 10:53:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jason Plum <jplum@devonit.com>,
	"burton.b.williams@gmail.com >> Burton Williams"
	<burton.b.williams@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192ee
References: <54C6F65A.90009@lwfinger.net> <B57A220D1EE1644685BA9AD5C790D205421EDC730D@SOUTHSIDE.devonintlgroup.com>
In-Reply-To: <B57A220D1EE1644685BA9AD5C790D205421EDC730D@SOUTHSIDE.devonintlgroup.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2015 08:19 AM, Jason Plum wrote:
> Larry,
>
> I know that to some degree I am jumping this chain. That being said, please allow me to offer encouragement in the development of the rtl8192ee, rtl872ae, and the other members of the rtlwifi_new github.
>
> I have been using these myself, and keeping them in my sights as my commercial product that has to support these drivers is being developed. There are some hiccups as is to be expected, but your work is greatly appreciated. I strive to keep our product as free of vendor proprietary code as much as possible and you work with rtlwifi_new and the available integration with multiple revisions of the kernel has been a recent key to that effort.

Note that everything in rtlwifi_new will soon be in the kernel. The bulk of the 
code was moved into V3.18 with some fixes applied to V3.19. A major hunk for BT 
coexistence for the RTL8812AE, which I have never seen, is in review, but should 
be available in V3.20. If Realtek has any new drivers in development, they have 
not told me.

For the next few months, my plan is to fix bugs, prune out any extraneous code, 
and identify routines used by 2 or more of the drivers and move them into the core.

Larry

