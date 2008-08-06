Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:36343 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYHFHtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 03:49:04 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3429492ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 00:49:02 -0700 (PDT)
To: Forest Bond <forest@alittletooquiet.net>
Subject: Re: Are these Ralink chips supported?
Date: Wed, 6 Aug 2008 10:14:10 +0200
Cc: linux-wireless@vger.kernel.org
References: <20080805163234.GA22429@storm.local.network>
In-Reply-To: <20080805163234.GA22429@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808061014.10483.IvDoorn@gmail.com> (sfid-20080806_094913_461637_3E0E78A5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 August 2008, Forest Bond wrote:
> Hi,
> 
> I'm having a hard time figuring out if the following wireless chips are
> supported:
> 
>  * RT2770 + RT2720

I *think* this is the rt2870 driver. The in-kernel driver is under development

>  * RT2571W/RT2571WF

This is the rt73usb driver

Ivo
