Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48403 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3DKTGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 15:06:35 -0400
Received: by mail-pb0-f41.google.com with SMTP id mc17so1013255pbc.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 12:06:35 -0700 (PDT)
Date: Thu, 11 Apr 2013 12:06:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 17/26] hostap: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130411190633.GB32045@kroah.com> (sfid-20130411_210641_748832_FA42C58E)
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411132952.32763.3184.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130411132952.32763.3184.stgit@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 11, 2013 at 02:29:52PM +0100, David Howells wrote:
> Don't use create_proc_read_entry() as that is deprecated, but rather use
> proc_create_data() and seq_file instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jouni Malinen <j@w1.fi>
> cc: John W. Linville <linville@tuxdriver.com>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: Johannes Berg <johannes@sipsolutions.net>
> cc: linux-wireless@vger.kernel.org
> cc: netdev@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
