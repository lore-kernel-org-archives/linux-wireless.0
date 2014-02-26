Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57374 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaBZQaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 11:30:15 -0500
Date: Wed, 26 Feb 2014 11:18:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge issue with wireless-testing
Message-ID: <20140226161834.GA3243@tuxdriver.com> (sfid-20140226_173025_019459_24B11049)
References: <530E03FF.2080608@broadcom.com>
 <530E04B5.4010905@broadcom.com>
 <530E0E4B.5020409@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530E0E4B.5020409@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 26, 2014 at 04:54:51PM +0100, Arend van Spriel wrote:
> On 02/26/2014 04:13 PM, Arend van Spriel wrote:
> > On 02/26/2014 04:10 PM, Arend van Spriel wrote:
> >> Hi John,
> >>
> >> Our internal kernel repository was still dangling on 3.14-rc1 (last
> >> merge from wireless-testing/master) so I thought it was time to tag
> >> along and do a new merge of wireless-testing/master, but I get a ship
> >> load of merge conflicts that I can not explain (see below). Did you
> >> rebase between rc1 and rc4? Hope you can end my confusion.
> > 
> > I tried to merge:
> > 
> > commit b8f6bdb12edb9b24114c746117087fdc9f75741e
> > Merge: e078763 b7b146c
> > Author: John W. Linville <linville@tuxdriver.com>
> > Date:   Tue Feb 25 15:36:46 2014 -0500
> > 
> >     Merge branch 'master' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/linvi
> > 
> >     Conflicts:
> >         drivers/net/wireless/ath/ath9k/recv.c
> 
> git diff between v3.14-rc4 tag and wireless-testing looks pretty normal
> except for these:
> 
>  arch/s390/kernel/compat_wrapper.S                  |    2 +-
>  arch/s390/pci/pci_dma.c                            |    8 +-
>  drivers/s390/cio/chsc.c                            |    1 +
>  drivers/s390/crypto/zcrypt_msgtype6.c              |   24 +-
>  security/selinux/ss/policydb.c                     |    8 +-
> 
> I think I will go and rebase instead of the merge.

I don't recall any thing weird since the -rc1 rebase.  I'm not sure
what the problem you are seeing might be?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
