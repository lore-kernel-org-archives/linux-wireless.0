Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55424 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZG0UXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 16:23:39 -0400
Received: by ewy26 with SMTP id 26so3479896ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 13:23:38 -0700 (PDT)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Pavel Roskin <proski@gnu.org>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
Date: Mon, 27 Jul 2009 21:22:11 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com> <200907272035.41193.chris2553@googlemail.com> <1248725279.7440.8.camel@mj>
In-Reply-To: <1248725279.7440.8.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907272122.11290.chris2553@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 July 2009, Pavel Roskin wrote:
> On Mon, 2009-07-27 at 20:35 +0100, Chris Clayton wrote:
> > On Monday 27 July 2009, Pavel Roskin wrote:
> > > But I think you may be getting something when the freeze happen.  But
> > > to see it, you need to be on a text console.  There are other ways to
> > > capture the kernel messages, which are described in the file
> > > Documentation/oops-tracing.txt in the Linux sources.
> >
> > I've taken some photos of the screen from the insertion of the card
> > through to ejecting it, and uploaded them to imageshack: They can be
> > viewed at:
> >
> > http://img145.imageshack.us/img145/8741/xdscn0647.jpg
> > http://img170.imageshack.us/img170/1954/xdscn0648.jpg
> > http://img195.imageshack.us/img195/807/xdscn0649.jpg
> > http://img195.imageshack.us/img195/9625/xdscn0650.jpg
> > http://img195.imageshack.us/img195/2717/xdscn0651.jpg
> > http://img170.imageshack.us/img170/6103/xdscn0652.jpg
> > http://img170.imageshack.us/img170/5844/xdscn0653.jpg
> >
> > Between them they should show all the output to the console, although
> > some do overlap a little.
> >
> > I hope they are helpful in tracking down this problem.
>
> Do you remove the card?  It's like the card is disconnected at some
> point, either physically or logically.

Yes, I remove the card once the laptop has frozen, because doing so "thaws" it again. The laptop is 
then usable until 2-5 minutes after I insert the card again, when it will freeze again. I can 
repeat this cycle over and over.

>
> It looks like a problem specific to the hardware, not anything in the
> common wireless code.  I suggest that you post your question to
> users@rt2x00.serialmonkey.com.  That's the mailing list for rt61pci and
> other Ralink devices.

I think I'll just configure MAC80211 power saving off or use the ath5k card that I also own.

Thanks anyway.

Chris
-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
