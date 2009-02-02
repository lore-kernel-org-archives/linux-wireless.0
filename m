Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45108 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZBBXTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 18:19:01 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 15:19:00 -0800
Date: Mon, 2 Feb 2009 15:18:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pat-lkml <pat-lkml@erley.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [patch resend] crda: rename nl_handle to nl_sock for libnl-2.0
Message-ID: <20090202231819.GF17941@tesla> (sfid-20090203_001907_042807_1E51B3D4)
References: <49861993.3080809@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <49861993.3080809@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 01, 2009 at 01:52:19PM -0800, pat-lkml wrote:
> Upstream has renamed nl_handle to nl_sock.  Update crda to the new names
> and add #define for libnl-1.1.
> 
> Signed-off-by: Pat Erley <pat-lkml@erley.org>

Applied, thanks!

  Luis
