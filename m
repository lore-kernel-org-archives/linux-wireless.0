Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36785 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbaJXSPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 14:15:07 -0400
Message-ID: <544A96C0.8030107@gmail.com> (sfid-20141024_201519_459481_07F65D3D)
Date: Fri, 24 Oct 2014 16:13:20 -0200
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Mike Galbraith <umgwanakikbuti@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	troy_tan@realsil.com.cn, netdev@vger.kernel.org,
	Thadeu Cascardo <cascardo@cascardo.eti.br>
Subject: Re: [PATCH V3.18] rtlwifi: Add check for get_btc_status callback
References: <1414081629-23002-1-git-send-email-Larry.Finger@lwfinger.net>	 <1414087731.5231.19.camel@marge.simpson.net>	 <5449478B.4070908@lwfinger.net> <1414116580.23080.10.camel@marge.simpson.net> <544A80B5.1090604@lwfinger.net>
In-Reply-To: <544A80B5.1090604@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2014 02:39 PM, Larry Finger wrote:
[...]
>
> Please try the attached patch. It replaces the second one I sent you. I
> will probably redo it before submitting the final copy, but this should
> work.
>
> Larry
>
Hi, Larry.

I've tried your patch on top of next-20141023 and it is still crashing 
on my laptop:

http://opsfelder.com/~murilo/lkml/next-20141023_plus_larry_patch_v2.jpg

-- 
Murilo
