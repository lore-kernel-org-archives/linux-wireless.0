Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:52713 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbXGEAIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 20:08:46 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2201756wxd
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2007 17:08:44 -0700 (PDT)
Message-ID: <1ba2fa240707041708h7295becg7ef3e7e152aeeb54@mail.gmail.com>
Date: Thu, 5 Jul 2007 03:08:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Benc" <jbenc@suse.cz>
Subject: Re: wmm_acm setting
Cc: "Cohen, Guy" <guy.cohen@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20070702184015.44fad5f9@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <D0122E209EBF8D4CAB38EC6A8AF244E502BCD5AC@hasmsx412.ger.corp.intel.com>
	 <20070702184015.44fad5f9@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somehow cannot find in wireless-dev.git
Can you paste it into email.
Thanks
Tomas

On 7/2/07, Jiri Benc <jbenc@suse.cz> wrote:
> On Sun, 24 Jun 2007 14:47:40 +0300, Cohen, Guy wrote:
> > In mac80211/ieee80211_sta.c, ieee80211_sta_wmm_params(), line ~267, is
> > wmm_acm setting for case 1 (BK) and case 0 (BE) right (and not swapped)?
>
> See commit 37c95ceeebd38a3f1f686b8fbf5168672d19f825 in wireless-dev and
> the referenced table.
>
>  Jiri
>
> --
> Jiri Benc
> SUSE Labs
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
