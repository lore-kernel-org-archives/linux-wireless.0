Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:31073 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751874AbYKKRRl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 12:17:41 -0500
Date: Tue, 11 Nov 2008 17:17:38 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem/bisect with rtl8187B
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4919BA54.8040802@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <893556.60482.qm@web23107.mail.ird.yahoo.com> (sfid-20081111_181758_573076_CC54E066)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 11/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hin-Tak Leung wrote:
> > --- On Tue, 11/11/08, Herton Ronaldo Krzesinski
> <herton@mandriva.com.br> wrote:
> > 
> > <snipped>
> >> Lets try to identify what part is broken, I guess
> is this,
> >> can you try this
> >> patch on latest wireless-testing?
> > 
> > Tried it, no improvement. 
> > 
> > Can you /did you see any problem similiar to mine with
> throughput on your system(s)?
> 
> I may see a slight improvement with the patch. Throughput
> using sftp goes from
> 386 KB/s to 460 KB/s when I put in the patch, but there is
> some jitter and that
> change may not be significant.
> 
> What rate-setting method are you using? I'm using
> "pid", which rapidly goes to
> 54 Mb/s on my device. I tried using minstrel and found that
> it gets an
> occasional burst of speed, but that it usually stays at 1
> Mb/s.

I am using "pid" according to dmesg (does "minstrel" says it is choosen if it is?) - I haven't done anything so it should be using the default rc method. What I found is that the rate reported by iwconfig (I also get 54Mb/s, without the feedback patch) has nothing to do with how fast I 
can move actual data...

Hin-Tak



      
