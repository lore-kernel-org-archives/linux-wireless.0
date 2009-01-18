Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12044 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782AbZARPei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 10:34:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 07:34:37 -0800
Date: Sun, 18 Jan 2009 07:34:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Michael Buesch <mb@bu3sch.de>
CC: Luis Rodriguez <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] crda: Throw verbose error message if M2Crypto is
	missing
Message-ID: <20090118153406.GV29609@tesla> (sfid-20090118_163440_872233_DEF8794D)
References: <200901181459.25771.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901181459.25771.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 05:59:25AM -0800, Michael Buesch wrote:
> Instead of throwing a cryptic Python backtrace, throw a better error message, if
> the M2Crypto module is not installed.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Thanks applied.

  Luis
