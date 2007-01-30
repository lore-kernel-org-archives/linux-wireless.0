Return-path: <wireless-bounces@tuxdriver.com>
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0UMpsoQ029877	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 17:52:25 -0500
Received: by an-out-0708.google.com with SMTP id c38so11395ana	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 14:51:45 -0800 (PST)
Date: Tue, 30 Jan 2007 17:41:44 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: Getting dscape running
In-reply-to: <03c901c744bd$78281930$68784b90$@com>
Sender: wireless-bounces@tuxdriver.com
To: Mark Wallis <mwallis@serialmonkey.com>
Cc: wireless@lists.tuxdriver.org, rt2400-devel@lists.sourceforge.net
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <9e4733910701301441m5da25df8u3390ee9241eb4812@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
 <03c901c744bd$78281930$68784b90$@com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

On 1/30/07, Mark Wallis <mwallis@serialmonkey.com> wrote:
> Hi Jon,
>
> > I have NetworkManager from CVS and the current version of
> > wpa_supplicant running. Hardware is a rt2570 dongle using the dscape
> > stack. OS is Ubuntu.
>
> Have you confirmed you are able to connect using iwconfig manually instead
> of Network Manager ? Are you able to get associated ?

check out my other post
>
> I assume you are using the rt2500usb.ko driver, but can you confirm
> you are using a recent CVS tarball ?

I'm using rt2500usb from the wireless-dev tree.
I'll pull from CVS and try your most recent code.

This is part of what makes working on wireless hard, the pieces are
scattered everywhere.

>
>
> Regards,
> Mark Wallis
> rt2x00 Project Admin
> mwallis@serialmonkey.com
>
>
>
>
>
>
>
>


-- 
Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
