Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51596 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2JYDxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 23:53:33 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so1177150obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 20:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHbMyCa_yUO1XMFRrxAhDCkO+0T1Z5HaQgjhAK6cK2J729O7Cw@mail.gmail.com>
References: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
	<1349099476.4315.12.camel@dcbw.foobar.com>
	<CAHbMyCa_yUO1XMFRrxAhDCkO+0T1Z5HaQgjhAK6cK2J729O7Cw@mail.gmail.com>
Date: Thu, 25 Oct 2012 05:53:32 +0200
Message-ID: <CAHbMyCYbhennrBXFzrJCp356D5T2FMkHg9zQgOza8_JSq+u=Eg@mail.gmail.com> (sfid-20121025_055336_825673_2F922D60)
Subject: Re: [Kernel Bug] 3.6, wpasupplicant 1.0, broadcom-sta 6.20.55.19
From: Jasmine Hassan <jasmine.aura@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 21, 2012 at 11:19 AM, Jasmine Hassan <jasmine.aura@gmail.com> wrote:
> However, scan results seem quite limited. That is, discovered BSSID's are
> noticeably fewer compared to results on 3.2.x-3.5.x, either via
> `/sbin/iwlist wlan1 scanning`, or networkmanager. Only 3-5 are show by
> iwlist, sometimes none, and network manager lists 6 at most.
> Same driver on 3.5 (or prior) quickly picks up at least 15 BSSIDs.

I take that back. Limited scanning was due to having laptop's lid
closed (and working on an external LED) while testing. Obviously, the
wifi card's antennae are in the bezel of the screen (doh).

Scanning actually seems even better now, in 3.6.x :)

Best,
Jasmine
