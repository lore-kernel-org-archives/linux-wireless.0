Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4095 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYGHOiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 10:38:22 -0400
Date: Tue, 8 Jul 2008 10:04:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>, herton@mandriva.com.br,
	proski@gnu.org, wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] rtl8187: Adding Realtek rtl8187B support
Message-ID: <20080708140457.GA10361@tuxdriver.com> (sfid-20080708_163826_469438_18454191)
References: <3ace41890807080412w3f24a8c1wa2665d8d6de785c9@mail.gmail.com> <48736E18.5060708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48736E18.5060708@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 08, 2008 at 08:39:36AM -0500, Larry Finger wrote:
> Hin-Tak,
>
> Good job getting these posted. For the first time in a long time, my unit 
> was able to connect and authenticate. It certainly looks as if you solved 
> the ep12 problem. I'm using the device to write this E-mail.
>
> Unfortunately, your mailer still wrapped some lines in the patches. It 
> wasn't difficult to repair them, but it still is a bother. For the next 
> round, we can work out a procedure that uses the mail utility to send the 
> patches. I've used this method since Linville was unable to process my 
> patches that were sent from Thunderbird.

FWIW, git-send-email does a decent job.  If you commit your patches
in a git tree, you can use git-format-patch to extract them and then
git-send-email to send them out -- works fairly well.

> The patch to revise the detection of B units with an 8187 ID is ready. I 
> can send it at any time.

Please do!

John
-- 
John W. Linville
linville@tuxdriver.com
