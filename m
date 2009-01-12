Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZALOyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 09:54:55 -0500
Subject: Re: [PATCH v3] libertas: if_spi, driver for libertas GSPI devices
From: Dan Williams <dcbw@redhat.com>
To: Colin McCabe <colin@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1231541889-7999-1-git-send-email-colin@cozybit.com>
References: <1231541889-7999-1-git-send-email-colin@cozybit.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 09:53:37 -0500
Message-Id: <1231772017.23907.3.camel@localhost.localdomain> (sfid-20090112_155458_778266_2E5E1ED8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-09 at 14:58 -0800, Colin McCabe wrote:
> Add initial support for libertas devices using a GSPI interface.  This has
> been tested with the 8686.
> 
> GSPI is intended to be used on embedded systems. Board-specific parameters are
> required (see libertas_spi.h).

Were you able to take a look at the alignment patches and see if just
using 'packed' worked, rather than having everything use
get_unaligned_*?

Dan


