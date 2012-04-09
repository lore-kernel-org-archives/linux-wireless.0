Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37785 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2DITcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 15:32:24 -0400
Date: Mon, 9 Apr 2012 15:26:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jan Simonson <jan@simonson.se>, linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
Message-ID: <20120409192630.GB26994@tuxdriver.com> (sfid-20120409_213308_691547_35C1DF3B)
References: <1502184.lhzNHmlX61@ymer>
 <4F81B9C4.1010901@lwfinger.net>
 <2210309.p6dWLepooK@ymer>
 <4F8306CF.4040503@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8306CF.4040503@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 09, 2012 at 10:57:03AM -0500, Larry Finger wrote:

> As I do not use Fedora, I was not aware of Fusion. Perhaps you could
> get them to reinstate this driver in their package. In addition, you
> might post a bug at Redhat in hopes that they will change their
> standard configuration. As a last resort, you could switch to a
> distro that includes this driver in their standard kernels.

Yeah, this is reasonable advice.  I don't know why Fusion droped this
package, but it might have been due to me making their life harder by
integrating compat-wireless directly into the Fedora kernels.  Since I
am no longer doing that, they may be willing to reverse that decision.

I don't really see including a staging driver in Fedora unless it is
clearly on the path to the "normal" part of the kernel.  Any chance
of that?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
