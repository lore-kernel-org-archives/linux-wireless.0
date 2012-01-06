Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41641 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2AFR0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 12:26:13 -0500
Received: by iaeh11 with SMTP id h11so2904100iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2012 09:26:13 -0800 (PST)
Message-ID: <4F072EB2.9050306@lwfinger.net> (sfid-20120106_182617_559997_67458DB6)
Date: Fri, 06 Jan 2012 11:26:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: how to uninstall the b43 and reinstall
References: <4F070CF4.5030708@gmail.com> <4F07186D.7020708@lwfinger.net> <16960B23-D3DA-4104-8F38-662DFA8D0A3E@gmail.com>
In-Reply-To: <16960B23-D3DA-4104-8F38-662DFA8D0A3E@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2012 10:58 AM, lina wrote:
> Yes, did remove old kernel also removed my old built compact-wireless?
> Sorry im not in front of computer. Just check email by phone.

Kernel modules must be built for the kernel you are using. Yes, switching from 
3.2-rc6 to 3.2 removed compat-wireless. Reinstall it under kernel v3.2, and your 
4313 will work again.

Larry

