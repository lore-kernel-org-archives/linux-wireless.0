Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43324 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbZBBWz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 17:55:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 14:55:26 -0800
Date: Mon, 2 Feb 2009 14:54:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Luis R Rodriguez <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] crda: report if no supported version of libnl is found
Message-ID: <20090202225444.GE17941@tesla> (sfid-20090202_235548_497703_161CDEF3)
References: <20090130223305.15916.7954.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090130223305.15916.7954.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 02:33:06PM -0800, Pavel Roskin wrote:
> Otherwise, the error messase would be very confusing.

Heh yeah good catch. Applied, thanks.

  Luis
