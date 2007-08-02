Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:20800 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbXHBLLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 07:11:08 -0400
Received: by fk-out-0910.google.com with SMTP id z23so404376fkz
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 04:11:05 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Thu, 2 Aug 2007 13:15:18 +0200
Cc: linux-wireless@vger.kernel.org
References: <46B1B0AE.7050205@gmail.com>
In-Reply-To: <46B1B0AE.7050205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708021315.19626.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I was using rt2x00 with hostapd to create a AP and it worked fine in FC6 
> with rt2x00-cvs-2007020803.
> But after upgrading to F7 it stopped working. I am using kernel 
> kernel-2.6.22.1-41.fc7 which have a recent wireless-dev copy of the 
> driver but I just get this errors in dmesg:

<... snip...>

> Any idea whats going on?
> Can I provide more info to help finding a solution?
> I already reported it here before:
> http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=4042
> but got no usefull replies so I decided to try here.

Could you retry with a more recent version?

Ivo
