Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:41346 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbYDIOfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 10:35:30 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2359547fgb.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2008 07:35:28 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix key hwaccel race
Date: Wed, 9 Apr 2008 16:39:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1207689103.7442.1.camel@johannes.berg>
In-Reply-To: <1207689103.7442.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804091639.24321.IvDoorn@gmail.com> (sfid-20080409_153547_539824_75C658CB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  enum ieee80211_internal_key_flags {
>  	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
>  	KEY_FLAG_TODO_DELETE		= BIT(1),
> -	KEY_FLAG_TODO_HWACCEL		= BIT(2),
> +	KEY_FLAG_TODO_HWACCEL_ADD	= BIT(2),
> +	KEY_FLAG_TODO_HWACCEL_REMOVE	= BIT(2),
>  	KEY_FLAG_TODO_DEFKEY		= BIT(3),
>  	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(4),
>  };

Just to be sure, but the duplicate BIT(2) is correct?

Ivo
