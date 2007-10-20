Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41869 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbXJTGF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 02:05:26 -0400
Message-ID: <20071020020525.bnh9tejfbb400sw0@webmail.spamcop.net> (sfid-20071020_070532_342799_682D1717)
Date: Sat, 20 Oct 2007 02:05:25 -0400
From: Pavel Roskin <proski@gnu.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	<1ba2fa240710191714j645c8bfp87a2269b9c141c52@mail.gmail.com>
In-Reply-To: <1ba2fa240710191714j645c8bfp87a2269b9c141c52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Tomas Winkler <tomasw@gmail.com>:

> I've sent a patch that fixes that few days ago.It should be in the latest
> version 1.1.18 ''Fix rate setting in probe request for HW sacn'
> I did test it only with 4965 but it's a same code.

Yes, my copy of the repository has that.  It's the most recent commit.  
  And that patch is already in wireless-2.6/everything, because I  
tried to apply it manually and got a message that it's already applied.

I'm away from that router, but I remember that I checked carefully  
that I was testing the right driver.  Either I did something wrong  
anyway, or the fix for the rates was incomplete.

-- 
Regards,
Pavel Roskin
