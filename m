Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:33366 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXFQOyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2007 10:54:20 -0400
Date: Sun, 17 Jun 2007 10:47:37 -0400 (EDT)
From: James Morris <jmorris@namei.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Lameter <clameter@sgi.com>,
	Dave Airlie <airlied@linux.ie>,
	Andrea Righi <righiandr@users.sourceforge.net>,
	Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	Samuel Ortiz <samuel@sortiz.org>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Chad Tindel <ctindel@users.sourceforge.net>,
	Dan Aloni <da-x@monatomic.org>,
	Jay Vosburgh <fubar@us.ibm.com>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Eric Paris <eparis@parisplace.org>,
	Ingo Molnar <mingo@elte.hu>,
	linux-usb-devel@lists.sourceforge.net,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Paulo Pereira <pfmp.404@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc5: known regressions with patches
In-Reply-To: <46754400.2080101@googlemail.com>
Message-ID: <Line.LNX.4.64.0706171046190.1178@localhost.localdomain>
References: <4675430B.2000304@googlemail.com> <46754400.2080101@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 17 Jun 2007, Michal Piotrowski wrote:

> SELinux
> 
> Subject    : very high non-preempt latency in context_struct_compute_av()
> References : http://lkml.org/lkml/2007/6/4/78
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
>             James Morris <jmorris@namei.org>
> Patch      : http://lkml.org/lkml/2007/6/7/334
> Status     : patch available

This patch is queued for -mm, and will be submitted for 2.6.23.



- James
-- 
James Morris
<jmorris@namei.org>
