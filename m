Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:50186 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0KJLJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 06:09:20 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAAB8n7k010383
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 13:09:19 +0200
Subject: Re: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a
 DFS frequencies
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: "Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 13:02:58 +0200
Message-ID: <1289386978.20720.40.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 11:27 +0100, Oikarinen Juuso (Nokia-MS/Tampere)
wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The wl1271 does not support radar detection. Hence, prevent ad-hoc and
> active scanning on frequencies requiring DFS.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

For both of the patches:

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

-Tuomas

