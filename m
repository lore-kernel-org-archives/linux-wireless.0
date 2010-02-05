Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab0BEJOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 04:14:43 -0500
Date: Fri, 5 Feb 2010 10:11:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH v2] airo: fix setting zero length WEP key
Message-ID: <20100205091145.GA3032@dhcp-lab-161.englab.brq.redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com> <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com> <1265327773.4290.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1265327773.4290.43.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 04, 2010 at 03:56:13PM -0800, Dan Williams wrote:
> On Thu, 2010-02-04 at 13:07 +0100, Stanislaw Gruszka wrote:
> > Patch prevents call set_wep_key() with zero key length. That fix long
> > standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
> > "airo: clean up WEP key operations". Additionally print call trace when
> > someone will try to use improper parameters, and remove key.len = 0
> > assignment, because it is in not possible code path.
> 
> Could you send the hunk that touches airo_set_encode() separately
> please?  That's obviously correct and an easy ack, but isn't really
> related to the other hunks here.

I'm confused by your further patch, I'm deferring fixing this to you :)

Stanislaw
