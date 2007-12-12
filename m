Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51984 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbXLLKoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 05:44:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Brennan Ashton" <comphappy@gmail.com>
Subject: Re: b43 regression
Date: Wed, 12 Dec 2007 11:42:45 +0100
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200712101136.48669.mb@bu3sch.de> <200712111202.34101.mb@bu3sch.de> <b2d05de20712111916o7e7b0395j974c06591de38965@mail.gmail.com>
In-Reply-To: <b2d05de20712111916o7e7b0395j974c06591de38965@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712121142.45386.mb@bu3sch.de> (sfid-20071212_104438_172468_F7D3BEBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 04:16:22 Brennan Ashton wrote:
> On Dec 11, 2007 3:02 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Tuesday 11 December 2007 02:14:05 Brennan Ashton wrote:
> > > https://bugzilla.redhat.com/show_bug.cgi?id=412861
> > > I downloaded the source for 2.6.23.8-63.fc8.src.rpm the package that
> > > things started to stop working at, and could not find any part of this
> > > patch applied, so at least for that bug it is something else.
> > >
> >
> > Please find out which patch broke it then. Nobody but you can do this.
> 
> What do you use to hammer the card with data to see if if fails?  I

You can use iperf or simply wget some file from a http server in the
network.


-- 
Greetings Michael.
