Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbbEMSq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 14:46:28 -0400
Date: Wed, 13 May 2015 20:46:23 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, Kyle McMartin <kyle@kernel.org>
Subject: Re: [RFC v2 6/6] firmware: add firmware signature checking support
Message-ID: <20150513184623.GR23057@wotan.suse.de> (sfid-20150513_204648_235855_5DFC748D)
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
 <1431541436-17007-7-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431541436-17007-7-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2015 at 11:23:56AM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> As with module signing, we do a very simple search for a
> particular string appended to the firmware. There's both a
> config option and a boot parameter which control whether we
> accept or fail with unsigned firmware and firmware that are
> signed with an unknown key.
> 
> If firmware signing is enabled, the kernel will be tainted
> if a firmware is loaded that is unsigned or has a signature
> for which we don't have the key.

Sorry this commit log is obviously still from the v1, the cover
letter addresses the changes best...

 Luis
