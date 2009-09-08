Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:61898 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZIHTex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 15:34:53 -0400
Received: by qyk11 with SMTP id 11so3069198qyk.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 12:34:55 -0700 (PDT)
Date: Tue, 8 Sep 2009 14:53:32 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: rt2x00 Users List <users@host1.serialmonkey.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] rt2x00: Hardcode TX ack timeout and consume time
Message-ID: <20090908125332.GA29495@linux-m68k.org>
References: <200909061514.23611.IvDoorn@gmail.com> <20090908120608.GA4296@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090908120608.GA4296@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 08, 2009 at 02:06:09PM +0200, Richard Zidlicky wrote:
> 
> it does significantly improve rt73usb performance and stability of ping times.

further data.. downloads improve significantly but uploads still require manual rate
setting else they fall back to 1MBit immediately.

Richard
