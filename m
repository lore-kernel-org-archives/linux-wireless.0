Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3871 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbXJJRMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 13:12:12 -0400
Date: Wed, 10 Oct 2007 12:59:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: automatically re-associate
Message-ID: <20071010165921.GG5962@tuxdriver.com> (sfid-20071010_181214_613823_AB9CD9FA)
References: <200710091404.31491.hs4233@mail.mn-solutions.de> <200710091713.35595.hs4233@mail.mn-solutions.de> <1191944257.20014.3.camel@localhost.localdomain> <200710100943.33106.hs4233@mail.mn-solutions.de> <1192028338.9739.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192028338.9739.28.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 10:58:58AM -0400, Dan Williams wrote:

> I won't throw a hissy fit over the reassociation patch as long as it
> only tries this in open & WEP situations where a supplicant is not
> necessary.  That means you cannot simply requeue an association in
> libertas_mac_event_disconnected(), but you should check the association
> request and not requeue if:
> 
> 1) the assoc request's mode is ad-hoc (is there a point to retrying
> assoc in adhoc?)

I'm not sure I see why ad-hoc is a special case?

John
-- 
John W. Linville
linville@tuxdriver.com
