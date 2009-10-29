Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55066 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbZJ2Rna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 13:43:30 -0400
Received: by pwj9 with SMTP id 9so184058pwj.21
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 10:43:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <209743CECB91EB4F84169A51F300410D97BA47DBF4@MAIL02.ug.kth.se>
References: <209743CECB91EB4F84169A51F300410D97BA47DBF4@MAIL02.ug.kth.se>
Date: Thu, 29 Oct 2009 10:43:35 -0700
Message-ID: <45e8e6c40910291043h68397035m4ca53eb08786051a@mail.gmail.com>
Subject: Re: mesh support for rt73
From: Andrey Yurovsky <andrey@cozybit.com>
To: Dan Rosenqvist <danro@kth.se>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Thu, Oct 29, 2009 at 6:19 AM, Dan Rosenqvist <danro@kth.se> wrote:
> Hi,
>
> I'm currently trying to set up a small 802.11s mesh network. As I've come to understand there's no support for mesh networking at the moment for rt 73 based cards (using DWL-G122 C1).
>
> Is it possible to implement the changes mentioned in http://linuxwireless.org/en/developers/Documentation/mac80211/API to support mesh networks for rt 73 as well?
> Is there someone out there currently working on this? Otherwise, how could I contribute to make this work?
>
> Regards,
> Dan--

rt73 devices are driven by the rt2x00 driver, in my case the interface
driver is rt73usb and the core driver is rt2x00.  That does support
mesh although there's an issue related to beaconing:
http://bugzilla.kernel.org/show_bug.cgi?id=13752

  -Andrey
