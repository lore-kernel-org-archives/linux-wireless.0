Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15697 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZAJATM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 19:19:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 16:19:12 -0800
Date: Fri, 9 Jan 2009 16:18:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] crda: prevent key2pub.py from generating bogus output
	on failure
Message-ID: <20090110001852.GK4416@tesla> (sfid-20090110_011915_115115_DC996AFB)
References: <20090110001650.3681.35686.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090110001650.3681.35686.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 09, 2009 at 04:16:50PM -0800, Pavel Roskin wrote:
> Specify output file on the command line, so that it's not created in
> case of fatal errors, such as asbence of M2Crypto.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks, BTW these should be addressed to John as its his tree.

  Luis
