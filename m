Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48874 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464AbZCMPAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 11:00:42 -0400
Date: Fri, 13 Mar 2009 10:57:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Which APs to disregards from in inputting into the bss list
Message-ID: <20090313145726.GD5551@tuxdriver.com> (sfid-20090313_160050_727451_AAF7CA61)
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com> <20090313080359.GA13826@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090313080359.GA13826@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2009 at 10:03:59AM +0200, Jouni Malinen wrote:
> On Thu, Mar 12, 2009 at 08:09:53PM -0700, Luis R. Rodriguez wrote:

> > The benefit I see with these early checks we won't get complaints
> > about not being able to connect to bogus APs or APs you shouldn't be
> > connected to anyway.
> 
> Those would be replaced with complaints about not seeing APs, scan
> being broken, and not being able to connect to APs that we should be
> able to connect to..

My thoughts exactly...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
