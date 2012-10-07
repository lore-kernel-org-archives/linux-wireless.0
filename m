Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1494 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2JGKRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2012 06:17:15 -0400
Message-ID: <50715599.9020708@broadcom.com> (sfid-20121007_121718_384216_DD0C4D3A)
Date: Sun, 7 Oct 2012 12:12:41 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ari Kuusava" <arikuu@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: [Kernel Bug] 3.6, wpasupplicant 1.0, broadcom-sta
 6.20.55.19
References: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
 <20121001113456.GA31313@tuxdriver.com>
 <CAHbMyCafN+08VCvgzY9coA+AO0aJzvxT3xRzUyQi75_5ij04xw@mail.gmail.com>
 <loom.20121007T111537-642@post.gmane.org>
In-Reply-To: <loom.20121007T111537-642@post.gmane.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2012 11:26 AM, Ari Kuusava wrote:
> I am on Gentoo and using wpasupplicant with Broadcom BCM4727 802.11 Hybrid
> Wireless Controller 5.100.82.112.
> Everything works perfect in 3,5,4
> Upgrading to 3,6,0 stable gives same bug as to you.
> Only thing chanced is kernel.
> So I believe that's kernel busines
>
> Have a nice dayservicemen

I think your device is not BCM4727 so can you give me 'lspci -v' output.

The broadcom-sta package is provided by the distros and maintained by 
Broadcom as it is a out-of-tree driver. That means it needs to keep up 
with the latest kernels, but it is lagging. Basically, this is the major 
disadvantage of *not* doing driver development upstream.

Issue with broadcom-sta package can be sent to:

	linux-wlan-client-support-list@broadcom.com

Regards,
Arend

