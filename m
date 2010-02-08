Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:9148 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0BHRdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 12:33:07 -0500
Received: by qw-out-2122.google.com with SMTP id 9so701464qwb.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 09:33:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002081454.13561.sturmflut@lieberbiber.de>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <1265446793.4041.2.camel@johannes.local>
	 <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
	 <201002081454.13561.sturmflut@lieberbiber.de>
Date: Mon, 8 Feb 2010 09:26:05 -0800
Message-ID: <445f43ac1002080926y4912fa6n7d94ce3333e879f5@mail.gmail.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
From: Javier Cardona <javier@cozybit.com>
To: Simon Raffeiner <sturmflut@lieberbiber.de>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon,

On Mon, Feb 8, 2010 at 5:54 AM, Simon Raffeiner
<sturmflut@lieberbiber.de> wrote:
> Am Sonntag 07 Februar 2010 08:51:03 pm schrieben Sie:
>
>> It was supported for automated testing and experimentation (you could
>> then force certain topologies).
>
> Wouldn't one have to disable beaconing then, or at least automatic peering? IMO you can't force a topology if the nodes are still beaconing and establishing paths at the same time.

Automatic peering can be disabled via NL80211_MESHCONF_AUTO_OPEN_PLINKS.

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
