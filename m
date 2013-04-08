Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:51402
	"HELO yow.sam-i-am.me" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S934972Ab3DHWw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 18:52:59 -0400
Date: Mon, 8 Apr 2013 18:46:15 -0400
From: Sean MacLennan <seanm@seanm.ca>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Howells <dhowells@redhat.com>, gregkh@suse.de,
	viro@ZenIV.linux.org.uk, awong1@novell.com,
	linux-wireless@vger.kernel.org
Subject: Re: The rtl8192e procfs-based debug interface seems very broken
Message-ID: <20130408184615.38b20264@lappy.seanm.ca> (sfid-20130409_005313_492633_59354436)
In-Reply-To: <51634550.3090300@lwfinger.net>
References: <17570.1365415364@warthog.procyon.org.uk>
	<51634550.3090300@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 08 Apr 2013 17:31:44 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> David,
> 
> That whole driver is quite broken.
> 
> My initial response would be to delete the whole procfs structure. I
> have one of those devices, but I never use it. At the moment, I do
> not have time to add locking and test the changes.

The driver isn't optimal, but I use it daily in one laptop. So it does
work, it just has a few quirks :D

Is the procfs structure only used for debugging? Unless it is used by
user mode tools, I have never used it. I may try quickly commenting it
out and see if things still work.

Cheers,
   Sean
