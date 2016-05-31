Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40320 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbcEaJh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 05:37:56 -0400
Message-ID: <1464687471.3076.0.camel@sipsolutions.net> (sfid-20160531_113800_433134_6E01DD67)
Subject: Re: [PATCH] iw: Change socket configuration to avoid buffer
 allocation error
From: Johannes Berg <johannes@sipsolutions.net>
To: "Tribush, Gil" <gil.tribush@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 31 May 2016 11:37:51 +0200
In-Reply-To: <9500D1AF62AEC945997ED710048926644CF4360C@HASMSX106.ger.corp.intel.com>
References: <9500D1AF62AEC945997ED710048926644CF4360C@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-05-18 at 11:22 +0000, Tribush, Gil wrote:
> Move  nl_socket_set_buffer_size() to be called after genl_connect(),
> otherwise nl_socket_set_buffer_size() always returns an NLE_BAD_SOCK
> error because sk->s_fd is equal to -1 at that stage.
> 

Applied.

johannes
