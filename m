Return-path: <wireless-bounces@tuxdriver.com>
Received: from smtp156.iad.emailsrvr.com
 (smtp156.iad.emailsrvr.com	[207.97.245.156])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V0r1r9001401	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 19:53:27 -0500
Date: Tue, 30 Jan 2007 19:54:09 -0500
From: Daniel Drake <dsd@gentoo.org>
Subject: Re: SIOCGIWRANGE and dscape
In-reply-to: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
Sender: wireless-bounces@tuxdriver.com
To: Jon Smirl <jonsmirl@gmail.com>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <45BFE8B1.2070104@gentoo.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

Jon Smirl wrote:
> I can work on this, but how should it be done? There is no callout
> from the stack to the drivers for this IOCTL. It also doesn't make
> sense that each driver have the code to build the entire channel
> lists. But you do need to know whether the driver is b/g or a/b/g. How
> does the driver indicate which channel domain it is in, Japan/US/EU?

This isn't a small project and is one of the remaining significant 
things that some people would like to see before devicescape gets merged.

As you note, drivers do need to inform the stack of basic capabilities, 
regulatory domain, supported reg domains, etc. And yes, channel 
'databases' and frequency mappings should be stack level or higher.

I don't think there is an answer to your questions at the moment - this 
is stuff that needs both designing and implementing. Good luck :)

Daniel
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
