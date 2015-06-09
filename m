Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52929 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbbFILBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 07:01:37 -0400
Message-ID: <1433847693.1892.10.camel@sipsolutions.net> (sfid-20150609_130146_231982_46C6F1C9)
Subject: Re: about .dump_station() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 09 Jun 2015 13:01:33 +0200
In-Reply-To: <5576C574.6050905@broadcom.com>
References: <5576AFA2.9090004@broadcom.com>
	 <1433842889.1892.9.camel@sipsolutions.net> <5576C574.6050905@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 12:52 +0200, Arend van Spriel wrote:

> Thanks. Guess it is nl80211.c assuring that. I should have checked that 
> first. See that I have to return -ENOENT when iteration is done.

Right.

> > If it would help, we could instead give the driver one or two pointers
> > to unsigned long values that start out as 0 and can be controlled
> > entirely by the driver?
> 
> Not sure if I understand this. What would those pointers represent?

Well, you could put in there whatever you like :)

Though realistically I wouldn't expect you to put anything other than
the sta_idx that you currently get.

johannes

