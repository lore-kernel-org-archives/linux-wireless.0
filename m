Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4334 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZG0UIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 16:08:01 -0400
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Pavel Roskin <proski@gnu.org>
To: chris2553@googlemail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200907272035.41193.chris2553@googlemail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907270235l19e9c2d9kb33dae2d6a0f78@mail.gmail.com>
	 <1248704860.2834.6.camel@mj>  <200907272035.41193.chris2553@googlemail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 16:07:59 -0400
Message-Id: <1248725279.7440.8.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 20:35 +0100, Chris Clayton wrote:
> On Monday 27 July 2009, Pavel Roskin wrote:
> >
> > But I think you may be getting something when the freeze happen.  But to
> > see it, you need to be on a text console.  There are other ways to
> > capture the kernel messages, which are described in the file
> > Documentation/oops-tracing.txt in the Linux sources.
> 
> I've taken some photos of the screen from the insertion of the card through to ejecting it, and 
> uploaded them to imageshack: They can be viewed at:
> 
> http://img145.imageshack.us/img145/8741/xdscn0647.jpg
> http://img170.imageshack.us/img170/1954/xdscn0648.jpg
> http://img195.imageshack.us/img195/807/xdscn0649.jpg
> http://img195.imageshack.us/img195/9625/xdscn0650.jpg
> http://img195.imageshack.us/img195/2717/xdscn0651.jpg
> http://img170.imageshack.us/img170/6103/xdscn0652.jpg
> http://img170.imageshack.us/img170/5844/xdscn0653.jpg
> 
> Between them they should show all the output to the console, although some do overlap a little.
> 
> I hope they are helpful in tracking down this problem.

Do you remove the card?  It's like the card is disconnected at some
point, either physically or logically.

It looks like a problem specific to the hardware, not anything in the
common wireless code.  I suggest that you post your question to
users@rt2x00.serialmonkey.com.  That's the mailing list for rt61pci and
other Ralink devices.

-- 
Regards,
Pavel Roskin
