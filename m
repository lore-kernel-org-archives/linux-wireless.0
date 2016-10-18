Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56272 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755723AbcJROMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:12:53 -0400
Message-ID: <1476799968.6425.33.camel@sipsolutions.net> (sfid-20161018_161257_012548_FF96F538)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Tue, 18 Oct 2016 16:12:48 +0200
In-Reply-To: <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 15:51 +0200, Markus Heiser wrote:
> Here are my thoughts ...
> 
> Every extension which is not a part of the sphinx distro brings new
> external dependencies 

I agree.

> and the development of such extensions is IMO
> far of kernel development's scope.

Arguably, having good documentation *is* in the scope of kernel
development.

Also, it could be argued that shipping a module in the kernel sources
would be more reliable than having to require it being externally
installed, like the GCC plugins perhaps.

> ATM, there are not many use cases for diagram generators, so why not
> be KISS and creating diagrams with the favorite tool only adding the
> resulting (e.g.) PNG to the Kernel's source?

*Only* adding the PNG would be awful, I'd have to keep track of the
corresponding source elsewhere, and perhaps couldn't even GPL it
because then I couldn't distribute the PNG without corresponding
source...

Adding the source text would really be the only practical choice, but
doing so makes it easy to mismatch things, and also very easy to use
proprietary services for it that may go away at any time, etc.

> Before we add new dependencies / complexity, we should get rid
> of the DocBook build.

That argument is ... completely bogus, politely said.

I'm not going to (be able to) do anything about all the docbooks that
exist, and have in fact converted the one docbook that I know anything
about. Holding back the development of documentation in one subsystem
because another subsystem hasn't converted is a garbage argument.

johannes
