Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZESAnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 20:43:24 -0400
Date: Mon, 18 May 2009 20:43:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Kossifidis <mickflemm@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com, me@bobcopeland.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath5k: prevent infinite loop
In-Reply-To: <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com> <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 19 May 2009, Nick Kossifidis wrote:
> 
> This is already fixed on wireless-testing ;-)
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD

Thanks, but this does only half. Although I did not hit this in my laptop, 
it can be an issue. If step[0] == step[1] you have the same problem.

-- Steve

