Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57663 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2ADQpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 11:45:07 -0500
Date: Wed, 4 Jan 2012 11:31:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-04
Message-ID: <20120104163109.GF2540@tuxdriver.com> (sfid-20120104_174547_893687_3CD25451)
References: <20120104155816.GE2540@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120104155816.GE2540@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 04, 2012 at 10:58:16AM -0500, John W. Linville wrote:

> I was hesitant to include the rtlwifi fix, but settled on inclusion
> because it was a product of a recent ginormous thread about the
> intersection of firmware loading and suspend/resume.  Plus it fixes
> a bug report in the Red Hat Bugzilla. :-) If you don't think it is
> worthy, let me know and I'll drop it from this release.

It looks like this could generate a build warning...

	http://marc.info/?l=linux-wireless&m=132569396407866&w=2

I'm getting cold feet on this one.  I withdraw this pull request --
new one to follow soon!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
