Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41761 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2HQFEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 01:04:05 -0400
Received: by obbuo13 with SMTP id uo13so4745219obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 22:04:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <01f801cd7b91$41fee2b0$c5fca810$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A3190138F360@sbs2003.acksys.local>
 <CAG6hwVMir23S-v0p=r=vkDn5Cu7fOSSEXaAU5jtSrVsC-Bp4ow@mail.gmail.com> <01f801cd7b91$41fee2b0$c5fca810$@acksys.fr>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 16 Aug 2012 22:03:45 -0700
Message-ID: <CAG6hwVOthC1of4HVfJ5SwJHgbWqFVPvr2v9p0HH2X2A+MQsTzQ@mail.gmail.com> (sfid-20120817_070435_531524_8F456BCD)
Subject: Re: Mesh addressing issue
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 16, 2012 at 2:26 AM, voncken <cedric.voncken@acksys.fr> wrote:
>         Computer.pcap : This capture show the ICMP request sent by the
> computer. The MAC address destination is unicast.
>         Mp2_to_mp1.pcap : this capture show the ICMP request (frame 33)
> from MP2 to MP1 in mesh network.  The MAC address destination is broadcast

This is clearly wrong, thanks for reporting. Expect a patch fixing this shortly.

Thomas
