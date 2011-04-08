Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1DHUzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 16:55:50 -0400
Date: Fri, 8 Apr 2011 13:57:20 -0700
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Removal of staging/rt2860sta (and rt2870sta)
Message-ID: <20110408205720.GA16065@Pilar.site>
References: <4D9F2185.10108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D9F2185.10108@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri,  8 Apr 2011 at  9:53:57 -0500, Larry Finger wrote:
> 
> I did the changes on my local git tree, committed them, and used
> 'git format-patch'. I expected that 'git rm' statements would be
> used to delete the files, but I got normal patch format. As a
> result, the resulting patch is over 2.4 GB, and has over 75,000
> lines. Obviously, I'm reluctant to dump a patch of this size on the
> lists. Is there a way to force git to use "rm" statements, or is
> there some way to handle this large patch?

I've just remembered about this patch in the git list, which I think
does what you want:

http://thread.gmane.org/gmane.comp.version-control.git/170537/focus=170581

