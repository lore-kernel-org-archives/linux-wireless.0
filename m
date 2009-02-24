Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51996 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZBXPAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 10:00:21 -0500
Date: Tue, 24 Feb 2009 09:55:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Luis R Rodriguez <mcgrof@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] crda: allow loading of regulatory.bin from /lib/crda
	in addition to /usr/lib/crda
Message-ID: <20090224145532.GB3536@tuxdriver.com> (sfid-20090224_160024_773703_340E94A3)
References: <200902241531.50649.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200902241531.50649.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:31:50PM +0100, Helmut Schaa wrote:
> As crda is typically installed in /sbin it might be worth to install
> regulatory.bin into /lib/crda instead of /usr/lib/crda. Hence, extend
> crda to try both paths for loading the database.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Is it worthwhile to add /usr/local/lib/crda too?  That way a user could
override the regulatory.bin without disturbing the distro's packaging.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
