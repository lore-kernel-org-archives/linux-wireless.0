Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:64917 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYFMR4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 13:56:33 -0400
Received: by an-out-0708.google.com with SMTP id d40so1002629and.103
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 10:56:32 -0700 (PDT)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug #10821] rt25xx: lock dependancy warning, association failure, and kmalloc corruption
Date: Fri, 13 Jun 2008 20:09:57 +0200
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christian Casteyde <casteyde.christian@free.fr>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	bugme-daemon@bugzilla.kernel.org
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.pGD.22vSIB@albercik> <20080613140037.GC21341@cs181133002.pp.htv.fi>
In-Reply-To: <20080613140037.GC21341@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806132009.58612.IvDoorn@gmail.com> (sfid-20080613_195649_319264_32BB88A7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 June 2008, Adrian Bunk wrote:
> On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> >...
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
> > Subject		: rt25xx: lock dependancy warning, association failure, and kmalloc corruption
> > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > Date		: 2008-05-29 14:30 (10 days old)
> 
> 
> Ivo, can you look at this 2.6.26-rc regression?

Sure, both issues should have been fixed in 2.6.26-rc5 :)

Ivo
