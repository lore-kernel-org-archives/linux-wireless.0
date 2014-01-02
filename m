Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43131 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaABXkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 18:40:39 -0500
Received: by mail-yh0-f53.google.com with SMTP id b20so2965200yha.26
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 15:40:39 -0800 (PST)
Date: Thu, 2 Jan 2014 15:40:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question on compiler warning
In-Reply-To: <52C5E4C9.7030500@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1401021539110.492@chino.kir.corp.google.com> (sfid-20140103_004045_359555_7FD63986)
References: <52C21CE3.3020402@lwfinger.net> <alpine.DEB.2.02.1401021354400.21537@chino.kir.corp.google.com> <52C5E4C9.7030500@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2 Jan 2014, Larry Finger wrote:

> I am definitely building this driver in my configuration. Variable
> CONFIG_CC_OPTIMIZE_FOR_SIZE was not set, but changing it to "y" did not change
> the result.
> 

I get this warning with gcc-4.6.3 and my gcc-4.5.1 cross compiler.
