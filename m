Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f185.google.com ([209.85.210.185]:48107 "EHLO
	mail-yx0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab0CEEJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 23:09:29 -0500
Received: by yxe15 with SMTP id 15so1853455yxe.25
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 20:09:29 -0800 (PST)
Message-ID: <4B9083F6.5080503@lwfinger.net>
Date: Thu, 04 Mar 2010 22:09:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gus Wirth <gwirth79@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187 coverage class
References: <4B906A81.6090703@gmail.com>
In-Reply-To: <4B906A81.6090703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2010 08:20 PM, Gus Wirth wrote:
> I'm trying to implement a first go at getting coverage class working for
> a Realtek RTL8187L chip similar to the way it is in ath5k. I know I need
> to change the ack timeout and the slot times but I can't quite decipher
> the register use. I can see some hints in the function rtl8187_conf_erp
> but that doesn't seem enough.
> 
> It seems that the values for SLOT, DIFS and EIFS aren't directly
> converted to microseconds, so I'm not sure how those values were arrived at.

Those values come from the vendor driver where they are not explained. The
difference between short and long slot values may be instructive.

Larry
