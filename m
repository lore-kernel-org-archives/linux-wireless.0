Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2873 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbXJPSiy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 14:38:54 -0400
Date: Tue, 16 Oct 2007 14:17:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Daiker <daikerjohn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Ath5k compile error in wireless-2.6.git
Message-ID: <20071016181745.GC5677@tuxdriver.com> (sfid-20071016_193859_142678_701CC6C2)
References: <4713EBCA.8010700@gmail.com> <20071015234601.GA4125@tuxdriver.com> <20071015234748.GB4125@tuxdriver.com> <43e72e890710160914g2caa998cpd7bbb058fd064372@mail.gmail.com> <20071016170155.GB5677@tuxdriver.com> <43e72e890710161105l4dbd5dc4rc43f241aed42ac92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890710161105l4dbd5dc4rc43f241aed42ac92@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 16, 2007 at 02:05:24PM -0400, Luis R. Rodriguez wrote:
> On 10/16/07, John W. Linville <linville@tuxdriver.com> wrote:

> > I think this has more to do with the git version (i.e. release) than
> > the architecture.  "Approach 1" worked everywhere for a long time,
> > while I only became aware of "Approach 2" a few months ago.
> 
> On my x86 box I have git 1.5.2.5
> On my PPC box have git 1.5.3.4
> 
> And no dice on the PowerPC box. Maybe I have to do a new pull with the
> new release.. I'll try.

It might have to do with whether you started with "git clone" or by
simply rsync'ing the repository.  In the latter case, "Approach 1"
probably works fine...?

Anyway, whatever works for you makes me happy. :-)

-- 
John W. Linville
linville@tuxdriver.com
