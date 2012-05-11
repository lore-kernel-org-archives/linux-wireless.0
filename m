Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2EKAUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 20:20:32 -0400
Received: by yhmm54 with SMTP id m54so2092935yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 17:20:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FAC2B98.6040100@microhardcorp.com>
References: <4FAC2B98.6040100@microhardcorp.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 10 May 2012 17:20:11 -0700
Message-ID: <CAG6hwVPanDNoWCK-dA2V3gpz8cJhQ-5oJZLXng0rrUXQngPPww@mail.gmail.com> (sfid-20120511_022036_313005_3E5BAF69)
Subject: Re: MESH only works at 54Mbps link rate or below?
To: Bin Zeng <bzeng@microhardcorp.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Bin,

On Thu, May 10, 2012 at 1:56 PM, Bin Zeng <bzeng@microhardcorp.com> wrote:
> Hi
>
> I created a MESH network by using 802.11n supported cards, however, MESH
> only works at 54Mbps link rate or below.
>
> Can anyone tell me how to active the 802.11n ht mode in mesh?

Just set the channel type to HT, something like:

iw wlan0 set channel 1 HT20

Before joining the mesh.

Thomas
