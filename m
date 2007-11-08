Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:44329 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbXKHLkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 06:40:25 -0500
Date: Thu, 8 Nov 2007 06:38:18 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Zhu Yi <yi.zhu@intel.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] WIRELESS:  Use more obvious "is_power_of_2" macro.
In-Reply-To: <1194512218.31257.308.camel@debian.sh.intel.com>
Message-ID: <Pine.LNX.4.64.0711080638030.18934@localhost.localdomain> (sfid-20071108_114029_807150_C783A548)
References: <Pine.LNX.4.64.0711060945510.5429@localhost.localdomain>
 <1194512218.31257.308.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Nov 2007, Zhu Yi wrote:

>
> On Tue, 2007-11-06 at 09:47 -0500, Robert P. J. Day wrote:
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
>
> NACK. is_power_of_2() cannot do compile time check for
> TFD_QUEUE_SIZE_MAX. Furthermore, the runtime check for
> TFD_QUEUE_SIZE_MAX is already done by iwl_queue_init().
>
> Thanks,
> -yi

right, sorry.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
