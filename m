Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1KXSb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:31:27 -0500
Subject: Re: [RFC v2 7/8] cfg80211 and nl80211: getting local and peer mesh
 power modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Mike Krinkin <krinkin.m.u@gmail.com>
In-Reply-To: <1321886416-12597-8-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154200_869030_6C31831B)
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	 <1321886416-12597-8-git-send-email-ivan.bezyazychnyy@gmail.com>
	 (sfid-20111121_154200_869030_6C31831B)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:31:24 +0100
Message-ID: <1322159484.5366.35.camel@jlt3.sipsolutions.net> (sfid-20111124_193130_543400_37336803)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:

> @@ -520,7 +522,9 @@ enum station_info_flags {
>  	STATION_INFO_BSS_PARAM          = 1<<15,
>  	STATION_INFO_CONNECTED_TIME	= 1<<16,
>  	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
> -	STATION_INFO_STA_FLAGS		= 1<<18
> +	STATION_INFO_STA_FLAGS		= 1<<18,
> +	STATION_INFO_LOCAL_MESH_PS_MODE = 1<<17,
> +	STATION_INFO_PEER_MESH_PS_MODE  = 1<<18
>  };

Did you ever even test this?

johannes

