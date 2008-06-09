Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:32822 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbYFICgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 22:36:38 -0400
Date: Sun, 8 Jun 2008 19:28:21 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>,
	Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
Subject: Re: Is configfs the right solution for configuration based fs?
Message-ID: <20080609022821.GL29740@mail.oracle.com> (sfid-20080609_043652_708172_500A8F2E)
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 08, 2008 at 02:25:36PM -0700, Luis R. Rodriguez wrote:
> I was really interested in looking to start a filesystem based
> approach for configuration of wireless a while back, an alternative to
> nl80211 if you will, but I stopped after I was told about some major
> issues with configfs. I forget the issues raised clearly so I'd like
> to bring this up for debate to see what really are the issues, what
> needs to be fixed so we can *properly* use a fs for configuration of
> subsystems. I thought configfs was the solution. We currently use and
> abuse debugfs, but it doesn't matter -- we don't expect users to
> depend on those files for ABI. It, however, it would be nice to
> finally export some of these values into a concise place so userspace
> *can* rely on them.

	I'd love to hear about the issues as well.  I'd also love to see
what you require, so as to either be able to explain how configfs can do
it for you, or to say that configfs isn't the right fit.  configfs is
designed with a particular goal, and some things don't fit that - and
that's fine.

> Perhaps a fs is not even the most optimized approach for size anyway
> so the benefits may just be helping with the easy design of userspace
> applications. Feedback on experiences are welcomed.
> 
> PS. I'm hoping those who *really* hate configs can comment

	You probably expect me to be all "configfs solves world peace,
how can you hate it?"  Nah.  I'd really like to understand your need and
how configfs doesn't fit.  configfs may not fit.  configfs may fit and
I need to explain it better.  Or configfs may not fit but should, and we
then can see how to make it right.

Joel

-- 

"Nothing is wrong with California that a rise in the ocean level
 wouldn't cure."
        - Ross MacDonald

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
