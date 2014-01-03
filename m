Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49075 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaACASE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 19:18:04 -0500
Message-ID: <52C601B8.4050909@lwfinger.net> (sfid-20140103_011831_565917_E7797F18)
Date: Thu, 02 Jan 2014 18:18:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wireless: delete non-required instances of include <linux/init.h>
References: <1388707112-5669-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1388707112-5669-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2014 05:58 PM, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>
> [Applied to net-next v3.13-rc4-1273-gde6fb28 ; Compile tested with
>   x86_64 allmodconfig, and ppc allmodconfig ; diffstat speaks for
>   itself somewhat.... ]

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>  - for rtl8187

Larry


