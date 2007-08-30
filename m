Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:47375 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXH3MYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 08:24:08 -0400
Received: by el-out-1112.google.com with SMTP id j27so210291elf
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2007 05:24:08 -0700 (PDT)
Message-ID: <c4db5c50708300524s75fe6acame25bc58f473f3ed1@mail.gmail.com>
Date: Thu, 30 Aug 2007 13:24:06 +0100
From: "Robin Cornelius" <robin.cornelius@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] [PATCH] Fix breakage on WEP for cards that rely on software decoding
Cc: "Adam Baker" <linux@baker-net.org.uk>,
	rt2400-devel@lists.sourceforge.net,
	"Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1188475206.2963.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200708282345.53016.adam@baker-net.org.uk>
	 <1188389382.19891.12.camel@johannes.berg>
	 <200708292223.02321.linux@baker-net.org.uk>
	 <1188475206.2963.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/30/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-08-29 at 22:23 +0100, Adam Baker wrote:
>
> > I can confirm that with that patch WEP is working for me. Another user on the
> > rt2x00 forum is also reporting success with it.
>
> Good. I'll be posting this patch for inclusion soon.
>

Hi Johannes,

A bit behind the boat here but another successful test (rt2x00:-
rt61pci, rt73usb and rt2500usb) here as well. Clears the issue for me.

Robin Cornelius
