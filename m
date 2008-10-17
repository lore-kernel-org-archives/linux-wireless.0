Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbYJQPST (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 11:18:19 -0400
Subject: Re: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: Dan Williams <dcbw@redhat.com>
To: myk.robinson@kingdomcomputer.info
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224248117.28593.3.camel@mobileOne>
References: <1224248117.28593.3.camel@mobileOne>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 11:16:59 -0400
Message-Id: <1224256619.3007.0.camel@localhost.localdomain> (sfid-20081017_171826_293671_65F1BF1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-17 at 07:55 -0500, Myk Robinson wrote:
> Hello-
> 
> Used your driver package in Ubuntu Hardy with no trouble at all. Testing
> the Intrepid beta now. Before today, using the compat-wireless driver
> for kernel 2.6.27, networkmanager showed all devices grayed out and

Hmm, what do you mean by "grayed out"?  What exactly did the menu say?

Dan

> iwlist scan would not work. Today's driver release has allowed me to
> connect, but still drops the connection with intel 2945abg. Also, it
> causes the touchpad to lose sync when the connection is dropped.
> 
> Here is a pastebin containing some dmesg info that might be helpful.
> 
> http://pastebin.com/f286ee42c
> 
> Thanks,
> 

