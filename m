Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2CJCRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 21:17:09 -0500
Received: by yenl12 with SMTP id l12so1375622yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 18:17:08 -0800 (PST)
Message-ID: <4F5AB9A1.7060802@lwfinger.net> (sfid-20120310_031714_244292_E515A2BB)
Date: Fri, 09 Mar 2012 20:17:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <30444020.391741.1331319970885.JavaMail.root@vms170029>
In-Reply-To: <30444020.391741.1331319970885.JavaMail.root@vms170029>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2012 01:06 PM, alupu@verizon.net wrote:
>
> Hi Larry,
>
> I applied the "debug" patch you sent and I followed your test instructions.
> Still, the same problem.
> Moreover I didn't see any debug output; maybe I'm missing something.
> The log of my test is attached.

Most of the messages were set to output only when the setting of the ESSID 
failed. Yours did not, and the ESSID was set. I was surprised to see you using 
my ESSID of "radius", and my WEP key (at least the obscured version I sent).

I have no idea what is going wrong on your system. All the proper routines are 
entered, and the data seem to be set correctly. I'm stumped.

Larry

