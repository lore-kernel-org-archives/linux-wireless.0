Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44337 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbYENDpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 23:45:21 -0400
Subject: Re: newbie rtl8187 question
From: Pavel Roskin <proski@gnu.org>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 23:45:18 -0400
Message-Id: <1210736718.2721.4.camel@rd> (sfid-20080514_054524_242191_8B0AAFC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 20:14 -0700, Paul Thomas wrote:
> Hello,
> 
> I am trying to get the Trendnet TEW-424UB to work. I have hardware
> version 3.1R which is based on the Realtek RTL8187B chip.

Somebody reported earlier today success with that adapter:
http://marc.info/?l=linux-wireless&m=121066467513930&w=2

I understand that two patches are needed on top of linux-wireless.

>         {USB_DEVICE(0x0bda, 0x8189)},

That is already in the first patch.

-- 
Regards,
Pavel Roskin
