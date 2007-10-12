Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iggypop2.siwnet.net ([81.216.65.12]:54798 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbXJLKHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 06:07:42 -0400
Message-ID: <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com> (sfid-20071012_110748_269160_708B9455)
In-Reply-To: <200710112005.56101.IvDoorn@gmail.com>
References: <fdqhn4$qab$1@sea.gmane.org>
    <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
    <1192094159.4770.21.camel@johannes.berg>
    <200710112005.56101.IvDoorn@gmail.com>
Date: Fri, 12 Oct 2007 11:04:05 +0200 (CEST)
Subject: Re: rt2500pci 2.0.9 not working
From: "Marcus Better" <marcus@better.se>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> Patch added below.

Kind-of works. I can connect but only at 1 Mb according to iwconfig.

>> printk(KERN_DEBUG "selected mode %d\n", local->oper_hw_mode->mode);
>> printk(KERN_DEBUG "select channel %d\n", local->oper_channel);

Oct 12 10:47:23 better kernel: selected mode 2
Oct 12 10:47:23 better kernel: select channel -539241232

Marcus


