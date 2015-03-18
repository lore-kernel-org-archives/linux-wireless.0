Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36502 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbbCRWUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 18:20:04 -0400
Received: by obdfc2 with SMTP id fc2so41662087obd.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 15:20:04 -0700 (PDT)
Message-ID: <5509FA11.4060105@lwfinger.net> (sfid-20150318_232008_368425_916D3CB4)
Date: Wed, 18 Mar 2015 17:20:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Orozco <felipe.orozco32@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: fast wireless restart on raspberry pi
References: <5162B74B-89E1-4A6D-AB76-8C5D55D15A99@gmail.com>
In-Reply-To: <5162B74B-89E1-4A6D-AB76-8C5D55D15A99@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2015 04:15 PM, Orozco wrote:
> Hello,
>
> I am working on a project where I need to be able to modify a wireless
> adapter's firmware. I'm trying to use the TP-LINK TL-WN821N with the
> 8192cu driver and firmware on a Raspberry Pi 2. I am trying to be able to
> quickly stop the transmission of packets then and just as quickly be able
> to restart the transmission. Ideally, I would be able to do a single
> stop/start in less time than it takes to transmit a packet.
>
> I would be very thankful if someone could tell me where would be a good
> place to start, and share any knowledge they have.

The firmware for the RTL8192CU is definitely not open source, and there is no 
documentation for the hardware. Modifying this firmware would be very difficult.

Larry


