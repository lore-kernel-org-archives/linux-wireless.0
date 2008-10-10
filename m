Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57732 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760103AbYJJSCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 14:02:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 11:02:11 -0700
Date: Fri, 10 Oct 2008 04:01:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Message-ID: <20081010110158.GG6766@tesla> (sfid-20081010_200216_215253_50ED95E0)
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 10:56:43AM -0700, Jiri Slaby wrote:
> status ath9k_hw_reset() parameter should be set in every case, since
> it is used in callers to find out an error code.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Thanks!

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
