Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:1467 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXLLDQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 22:16:23 -0500
Received: by wr-out-0506.google.com with SMTP id c49so58305wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2007 19:16:22 -0800 (PST)
Message-ID: <b2d05de20712111916o7e7b0395j974c06591de38965@mail.gmail.com> (sfid-20071212_031628_135585_20775077)
Date: Tue, 11 Dec 2007 19:16:22 -0800
From: "Brennan Ashton" <comphappy@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: b43 regression
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712111202.34101.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200712101136.48669.mb@bu3sch.de>
	 <b2d05de20712101714x38c2dec6la9c4f496732b053d@mail.gmail.com>
	 <200712111202.34101.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 11, 2007 3:02 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 11 December 2007 02:14:05 Brennan Ashton wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=412861
> > I downloaded the source for 2.6.23.8-63.fc8.src.rpm the package that
> > things started to stop working at, and could not find any part of this
> > patch applied, so at least for that bug it is something else.
> >
>
> Please find out which patch broke it then. Nobody but you can do this.

What do you use to hammer the card with data to see if if fails?  I
have been just surfing the web, and moving data back and forth, but it
is very inefficient and a poor form of a test. I think I may have
narrowed down the kernel were it starting failing, but I want to make
sure.

-- 
Brennan Ashton
Bellingham, Washington

"The box said, 'Requires Windows XP or better'. So I installed Linux"
