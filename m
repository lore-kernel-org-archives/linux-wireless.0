Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:39259 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZG0ThK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:37:10 -0400
Received: by ewy26 with SMTP id 26so3444728ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 12:37:08 -0700 (PDT)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Pavel Roskin <proski@gnu.org>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
Date: Mon, 27 Jul 2009 20:35:41 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com> <c6b1100b0907270235l19e9c2d9kb33dae2d6a0f78@mail.gmail.com> <1248704860.2834.6.camel@mj>
In-Reply-To: <1248704860.2834.6.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907272035.41193.chris2553@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 July 2009, Pavel Roskin wrote:
>
> But I think you may be getting something when the freeze happen.  But to
> see it, you need to be on a text console.  There are other ways to
> capture the kernel messages, which are described in the file
> Documentation/oops-tracing.txt in the Linux sources.

I've taken some photos of the screen from the insertion of the card through to ejecting it, and 
uploaded them to imageshack: They can be viewed at:

http://img145.imageshack.us/img145/8741/xdscn0647.jpg
http://img170.imageshack.us/img170/1954/xdscn0648.jpg
http://img195.imageshack.us/img195/807/xdscn0649.jpg
http://img195.imageshack.us/img195/9625/xdscn0650.jpg
http://img195.imageshack.us/img195/2717/xdscn0651.jpg
http://img170.imageshack.us/img170/6103/xdscn0652.jpg
http://img170.imageshack.us/img170/5844/xdscn0653.jpg

Between them they should show all the output to the console, although some do overlap a little.

I hope they are helpful in tracking down this problem.

Thanks,

Chris


-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
