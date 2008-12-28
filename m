Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:38284 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYL1NRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 08:17:49 -0500
Date: Sun, 28 Dec 2008 13:17:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mac80211: implement dynamic power save
Message-ID: <20081228131745.GA9554@srcf.ucam.org> (sfid-20081228_141759_323221_3842E353)
References: <20081218211532.6842.88104.stgit@tikku> <20081218211712.6842.98402.stgit@tikku> <20081224132432.GA27658@srcf.ucam.org> <87wsdkmp54.fsf@nokia.com> <20081228130650.GA9083@srcf.ucam.org> <87sko8mohv.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87sko8mohv.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 03:13:32PM +0200, Kalle Valo wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > It allows userspace applications to register their latency requirements. 
> > There's a notifier chain that then allows drivers (or subsystems) to be 
> > notified of the current requirements, the idea being that they can then 
> > limit their deepest power saving mode to one that still satisfies the 
> > userspace constraints.
> 
> Do these constrainsts also include network latency? Do you have any
> suggestions for bedtime reading? :)

Yes, one of the chains is network latency. It's documented in 
Documentation/power/pm_qos_interface.txt.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
