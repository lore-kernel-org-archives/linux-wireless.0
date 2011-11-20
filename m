Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li235-22.members.linode.com ([173.255.225.22]:32933 "EHLO
	erley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1KTVFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 16:05:53 -0500
Message-ID: <4EC96BAD.1000808@erley.org> (sfid-20111120_220555_406767_C93B3650)
Date: Sun, 20 Nov 2011 16:05:49 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	Jan de Jongh <jfcmdejongh@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: 802.11p implementation...
References: <CAFtRNNwXdeBfa-mFNyAVALgTxM-wrUthgMLS18VokqOSSiWPqg@mail.gmail.com> <1320585006.11133.2.camel@jlt3.sipsolutions.net> <CAFtRNNxGd7NSmjNhZboW5VOZ++j=D1E_G6E6RqXLA3Ssuu4XfQ@mail.gmail.com> <loom.20111112T202645-807@post.gmane.org> <CAFtRNNxJjiCtPAyM=KwD+rpXkZXCUgpuSw2BHpaxb6frxBWumA@mail.gmail.com> <4EC72081.5020605@erley.org> <CAJ-Vmok6-1Z7GZLTHU7-20OejX0YELHS3=fJtGzzXyvnxsAnTA@mail.gmail.com>
In-Reply-To: <CAJ-Vmok6-1Z7GZLTHU7-20OejX0YELHS3=fJtGzzXyvnxsAnTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2011 06:46 PM, Adrian Chadd wrote:
> Have you tested your half/quarter rate stuff against what other
> vendors are doing? (eg, the half/quarter rate support inside FreeBSD?)
>
>
>
> Adrian

No, my ZC901 cards use a 900mhz frequency shifter, and it uses a different channel
set than the UBI cards do.  I only have the 2, and due to their sizes, they can
only be used in my Routerstation Pros.  I'm putting together the e-mail to send
off right now.  All it took was adding debugfs entries for it, like was mentioned.

Pat
