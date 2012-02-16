Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegene.sat.lt ([88.119.145.12]:44413 "HELO bluegene.sat.lt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750845Ab2BPLUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 06:20:06 -0500
Date: Thu, 16 Feb 2012 13:18:34 +0200
From: Nerijus Baliunas <nerijus@users.sourceforge.net>
Subject: Re: iwl3945 cannot connect to zd1211rw AP
To: linux-wireless@vger.kernel.org
Message-ID: <Mahogany-0.68.0-3602-20120216-131834.01@nerijus.sat.lt> (sfid-20120216_122010_898595_D4E9016A)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
References: <Mahogany-0.68.0-758-20120215-003647.00@nerijus.sat.lt> <20120215084658.GA17573@redhat.com>
In-Reply-To: <20120215084658.GA17573@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 15 Feb 2012 09:46:59 +0100 Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Perhaps know zd1211 bug, we have one fix that I think can address that:
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=e81a7bd55531a77d8c16d44766db4089c2983f1b
> 
> We included that commit in the latest fedora kernel 3.2.6, check that out:
> http://koji.fedoraproject.org/koji/buildinfo?buildID=299356

Yes, this fix fixes it, thanks!

Regards,
Nerijus
