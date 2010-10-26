Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53355 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab0JZMqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:46:54 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9QCkQNI004875
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 15:46:51 +0300
Subject: Re: [PATCH 1/2] wl1271: Fix scan failure detection
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: "ext juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 15:40:50 +0300
Message-ID: <1288096850.17497.350.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 13:24 +0200, ext juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> In scan_complete_work, because the mutex is released before accessing the
> scan->failed flag, it is possible for unfounded hardware recovery rounds
> to be executed.
> 
> Fix this.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

Good work. I couldn't reproduce the error with this patch.

-Tuomas

