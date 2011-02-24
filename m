Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39749 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1BXAwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 19:52:15 -0500
Received: by yxs7 with SMTP id 7so21611yxs.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 16:52:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikq2XA9c9FUQJ3cv7xjL69J=tHxLdwj8fiNnmhN@mail.gmail.com>
References: <4D5DA039.9010907@gmail.com>
	<AANLkTikq2XA9c9FUQJ3cv7xjL69J=tHxLdwj8fiNnmhN@mail.gmail.com>
Date: Thu, 24 Feb 2011 00:52:14 +0000
Message-ID: <AANLkTikkv0QbzoHv_Z8cdDp7g67oG57tN7QaZv8NH4Na@mail.gmail.com>
Subject: Re: Google Summer of Code 2011 - Project ideas page for the Linux
 Foundation online
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Till Kamppeter <till.kamppeter@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Greg KH <greg@kroah.com>,
	"lsb-discuss@lists.linux-foundation.org"
	<lsb-discuss@lists.linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Open Printing <printing-architecture@lists.linux-foundation.org>,
	Lars Uebernickel <larsuebernickel@gmx.de>,
	peter sikking <peter@mmiworks.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 2:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Feb 17, 2011 at 2:24 PM, Till Kamppeter
> <till.kamppeter@gmail.com> wrote:
>> Hi,
>>
>> I have set up a page for project ideas for the Linux Foundation's
>> participation in the Google Summer of Code 2011:
>>
>> https://www.linuxfoundation.org/collaborate/workgroups/gsoc/google-summer-code-2011
>>
>> Please add your ideas to the sub-page of your work group. If you have
>> problems mail me with your project idea.
>
> For 802.11 you can dump your ideas here:
>
> http://wireless.kernel.org/en/developers/GSoC/2011/
>
>  Luis

Seeing as a few of the mac80211-based wireless drivers (for some of
the more dumb/basic/cheap devices) has gained access-point(AP)-mode
support code in the kernel recently in the last few months, it would
probably be appropriate to add (if it isn't already there) or enhance
access-point-mode support in some of the user-land tools like
NetworkManager, nm-applet, or wireless assistant? I think hostapd
doesn't care what type of drivers they are, except they need to claim
to support AP mode, so I think hostapd is okay... but of course there
are always the odd user-friendliness in various places that can do
with a bit of more work about "setting up a network service", e.g.
say, make it easier and more user-friendly to setting a bridge between
wireless client and wired connectivity. This involves configuring
hostapd, iptables for ip masquerading/network address translation, and
possibly a few other things.

Hin-Tak

P.S. Till: please feel free to recycle past unfinished ideas and sign
me up as possible mentors of relevant printer-stuff projects
