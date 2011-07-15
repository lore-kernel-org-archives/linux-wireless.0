Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52430 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1GOPPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 11:15:20 -0400
Received: by ywe9 with SMTP id 9so575718ywe.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 08:15:19 -0700 (PDT)
Message-ID: <4E205984.5040803@lwfinger.net> (sfid-20110715_171523_404504_073DE59B)
Date: Fri, 15 Jul 2011 10:15:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
References: <4E2051F3.20103@redhat.com>
In-Reply-To: <4E2051F3.20103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/2011 09:42 AM, Stefan Assmann wrote:
> Hi Larry,
>
> I'm wondering if you're looking into any issues concerning the
> driver. The problem I'm currently facing is that the driver does not
> recognize any network disconnects. So whenever the network goes down the
> driver will still report it's connected and thus doesn't reconnect when
> the network is up again.
>
> Btw I'm using a 0bda:8172 usb adapter with 2.6.39.
> Thanks for your help!

I need more details. What distro? How are you controlling the network? If 
NetworkManager, what version?

When this situation occurs, what is output to the dmesg log?

I do not see this situation on my system/device. Whenever the connection is 
dropped, NM reconnects.

There are a recent patches that might have an effect. Can you build your own kernel?

Larry
