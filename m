Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47058 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2IJSpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 14:45:15 -0400
Date: Mon, 10 Sep 2012 14:33:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 0/2] brcmsmac: fix for regulatory rules and flush callback
Message-ID: <20120910183335.GA2137@tuxdriver.com> (sfid-20120910_204548_440095_A4BD960E)
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <504DE996.4020709@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <504DE996.4020709@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2012 at 03:22:30PM +0200, Arend van Spriel wrote:
> On 09/05/2012 11:49 AM, Arend van Spriel wrote:
> >Two fixes intended for the wireless tree. The issue with the .flush() has
> >been giving me a lot of email from RedHat's bugzilla server. Hope this
> >patch will silence that ;-)
> 
> Hi John,
> 
> I should remove that smile above, but are you planning to take these
> for v3.6. At least the first patch is a clear bug fix that I would
> like
> to have applied.
> 
> Gr. AvS

Arend,

I held-off on these because of the continuing discussion...

I definitely 'feel your pain' re: Red Hat bugzilla and the second
patch.  But I'm not sure it meets either the 'small' or 'obvious'
tests, so I would prefer to leave it out for now.  I'll take the
first one now.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
