Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22362 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbYEVUvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 16:51:50 -0400
Subject: Re: [PATCH WIP] rtl8187b support
From: Pavel Roskin <proski@gnu.org>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f6ca9fed0805220846w3670fbe1i1cb28cc2d1b97288@mail.gmail.com>
References: <1211470467.10933.57.camel@dv>
	 <f6ca9fed0805220846w3670fbe1i1cb28cc2d1b97288@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 16:51:47 -0400
Message-Id: <1211489507.18709.22.camel@dv> (sfid-20080522_225156_182655_FF0995B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 17:46 +0200, drago01 wrote:
> On Thu, May 22, 2008 at 5:34 PM, Pavel Roskin <proski@gnu.org> wrote:
> 
> wouldn't it make sense to let rtl8225_write always call msleep(1) ?

Maybe.  I don't know much about the hardware.  Such code already exists
in the current driver.  Sometimes there is no delay, and sometimes it's
100 milliseconds.

I think the fix it to wait for the device to be ready, not just wait
blindly.

-- 
Regards,
Pavel Roskin
