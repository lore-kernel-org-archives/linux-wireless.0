Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60606 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0KJLge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 06:36:34 -0500
Message-ID: <4CDA83BD.2000306@ti.com>
Date: Wed, 10 Nov 2010 13:36:29 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
CC: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] Revert "wl1271: Change supported channel order for
 a more optimal scan"
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>	 <1289384840-28305-2-git-send-email-juuso.oikarinen@nokia.com>	 <4CDA7F7A.4000705@ti.com> <1289388086.2522.72.camel@wimaxnb.nmp.nokia.com>
In-Reply-To: <1289388086.2522.72.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2010 01:21 PM, Juuso Oikarinen wrote:
> On Wed, 2010-11-10 at 12:18 +0100, ext Gery Kahn wrote:
>> On 11/10/2010 12:27 PM, juuso.oikarinen@nokia.com wrote:
>>> From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
>>>
>>> This reverts commit fa21c7a9e4be439e217fe72edbd39b643b643791.
>>>
>>> The reverted patch caused more harm than benefit.
>>>
>>> Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
>>>
>> Just couple words what harm it was?
>
> The harm is that the supported channels are reported to user-space in
> the order they are registered in the driver. The result of that is quite
> messy in userspace PoV.
>
> -Juuso
>
Thank you for answer.

The reason of doing such channel sorting was channel overlapping.

Let's say for 11a (bandwidth 20MHz) it is not a problem.
While 11g, preferred channel sorting would be 1,6,11,...

Gery

