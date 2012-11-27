Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33333 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2K0Mqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 07:46:37 -0500
Message-ID: <1354020357.950.85.camel@cumari.coelho.fi> (sfid-20121127_134639_989409_9CB77BC3)
Subject: Re: [PATCH 09/11] wlcore: don't allow access to FW mem when chip is
 off
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Date: Tue, 27 Nov 2012 14:45:57 +0200
In-Reply-To: <1353945950-3899-10-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
	 <1353945950-3899-10-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 18:05 +0200, Arik Nemtsov wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Don't allow read/writes to FW memory when the FW is not powered on.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

As discussed in the other thread, I'll ignore this patch.

--
Luca.

