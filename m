Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46079 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LUPaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:30:35 -0500
Date: Wed, 21 Dec 2011 10:16:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Darshan Kumar NANDANWAR <Darshan.KN@st.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: insmod RTL8192CE OOPS on 2.6.32.16
Message-ID: <20111221151605.GA11842@tuxdriver.com> (sfid-20111221_163039_125233_EA97078F)
References: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com>
 <4EF1F32F.8070704@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4EF1F32F.8070704@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 08:54:39AM -0600, Larry Finger wrote:
> On 12/21/2011 06:06 AM, Darshan Kumar NANDANWAR wrote:
> >Larry ,
> >
> >I am using RTL8192CE driver for 2.6.32.16 for one of the DTV soc(sh4 cpu) ..
> >Once I insert it , I get following oops... The same oops is reported by *John
> >Linville in https://bugzilla.kernel.org/show_bug.cgi?id=40212 . But
> >unfortunately , given link is down ; so I am unable to get into the the
> >discussion. Could you please give me the pointers why it’s happening so?*
> >
> >Lspci is showing me correct vendor and product id which is : *0x10ec 0x8178*
> 
> I added the linux-wireless ML to the Cc list so that others will see this thread.
> 
> I do not remember the kernel bugzilla. Perhaps John does.

No, sorry -- I have no idea what that bug was.  I don't even think
I have the device in question, so I don't know how I could even have
produced a bug report!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
