Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:20265 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZHABeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 21:34:50 -0400
Received: by rv-out-0506.google.com with SMTP id f6so699273rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 18:34:50 -0700 (PDT)
Message-ID: <4A739A44.8000702@lwfinger.net>
Date: Fri, 31 Jul 2009 20:28:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jayant Sane <jayant_sane@hotmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Newbie question on 2.6.28-rc8-wl
References: <BLU129-W39120C9D5D733AC53C210180DB0@phx.gbl> <496A27FA.5030508@lwfinger.net> <BLU129-W353904E1AB1EEE7AC28C7D80D80@phx.gbl>
In-Reply-To: <BLU129-W353904E1AB1EEE7AC28C7D80D80@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jayant Sane wrote:
> 
> Thank you.
> 
> Again pardon my ignorance here..
> 
> It seems that I can either get 2.6.28-wl or 2.6.28-rc8 per your suggestions below but not 2.6.28-rc8-wl
> 
> And I know it is possible to have the kernel version reported as 2.6.28-rc8-wl.  How can I get that?

In the main directory, create a file named localversion-wireless with
a line that says -wl

If you did the steps I told you earlier, you have the same as
2.6.28-rc8-wl, no matter what it says.

Larry
