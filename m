Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56012 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1HCJQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 05:16:30 -0400
Received: by ywn13 with SMTP id 13so332376ywn.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 02:16:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E38DDB3.1030801@candelatech.com>
References: <4E38DDB3.1030801@candelatech.com>
Date: Wed, 3 Aug 2011 17:16:29 +0800
Message-ID: <CAJ-Vmon2Xwv3VqDhH9EouGiYgr0wfoEh3_41D4EscmForRDgaA@mail.gmail.com> (sfid-20110803_111646_525647_D019F420)
Subject: Re: Bridging wired to STA interfaces.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How do you propose handling the case where people will hook up >1 device?
Print out a very loud warning? :-)

I did something like this a while ago for a company and their first
request was exactly that - "Customer X now wants two devices in a
vehicle hooked up to the wireless, it doesn't work, what do we do?"


Adrian


On 3 August 2011 13:33, Ben Greear <greearb@candelatech.com> wrote:
> We have some interest in being able to bridge wired systems to
> (virtual) STA interfaces, primarily for using third-party
> traffic generation tools over virtual stations.
>
> I was thinking of writing a sta-bridge module that mapped
> incoming packets on a wired interface to a STA with MAC
> that matched the source MAC of the packet.  All packets
> received on the STA would be forwarded un-modified out
> the wired port.
>
> I think this would allow someone to create a STA interface
> with MAC matching a PC connected to the wired port and effectively
> have it be a transparent bridge between STA and PC.
>
> Has anyone attempted something like this before?
>
> Any interest in having this feature in the upstream kernel?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
