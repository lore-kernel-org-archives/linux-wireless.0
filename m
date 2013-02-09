Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36361 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3BIHj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2013 02:39:26 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so1615885wib.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 23:39:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3b_W0it4p9pY0rayuZu5yupMJPrGc2T6DTrKO-G27y4Vg@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAMgrJ3YQ5oua0MJvmVcbb-GuQ8Rr5vwAO3Jy1vs0w-VRRDdcMg@mail.gmail.com>
	<CAJ-VmomnvMqc_0sKvmL-_OQY4cm5xKjqfeWXs_jfUsvFtK9YcQ@mail.gmail.com>
	<CAMgrJ3bvJ-XwBGVcWuUGGyqAoJbjRFZz=om5dsG6MecRAYRO7g@mail.gmail.com>
	<CAJ-VmonzUE9uFN=tDfMXVF-b1Vk3c_+ZTWiGZKPgw8Vnwwadgw@mail.gmail.com>
	<CAMgrJ3ZHRMxzzxf0pj5zc+1TeWkfT2RPwL82JSkTU=AsYnXwfg@mail.gmail.com>
	<CAJ-VmomRvj2hf0i6AMJzCiR42thmTUQ=QCe7FX0k3tw1DTbkoQ@mail.gmail.com>
	<CAMgrJ3YCryn2VvtZJbJSVFUT61TQYPXw+cOXnJQN8Jab-rSuKA@mail.gmail.com>
	<CAMgrJ3b-_a5aBDjAMPChnxEWobnYOhXX3y_FwfNwF75u4hHD6A@mail.gmail.com>
	<CAJ-VmombhTgTaFuQXWR1Q4M8Awg4CwFseDu+iN_U6GfBDUaCig@mail.gmail.com>
	<CAMgrJ3bLJyVYa47zxGgNOcks0bK70oo1w1JLObW4DT_vpyU_SA@mail.gmail.com>
	<CAJ-VmomvQKNHP008vXA8dHrSnG1mUkkx1yoBy6B1jwv_VxTZjw@mail.gmail.com>
	<CAMgrJ3b_W0it4p9pY0rayuZu5yupMJPrGc2T6DTrKO-G27y4Vg@mail.gmail.com>
Date: Fri, 8 Feb 2013 23:39:24 -0800
Message-ID: <CAJ-Vmok-iP+=6EK+mG+jqnEPY2gPLhypjcGKxceEvy=EG59Ngw@mail.gmail.com> (sfid-20130209_083930_181366_92A9E054)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2013 10:48, Robert Shade <robert.shade@gmail.com> wrote:
> Maybe I have the terminology wrong, but I thought a cold reset meant
> toggling the PCI reset line.

That's a very very cold reset line, that resets the PCI bus glue
inside the chip.

There's a bunch of different reset lines; most of the device can be
reset without resetting the PCI/PCIe host interface.

So a "cold" reset here is resetting almost everything inside the chip
by pulling down those reset lines and stopping/restarting clocks.


Adrian
