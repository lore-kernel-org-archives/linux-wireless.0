Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:46896 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbXK0Oyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 09:54:31 -0500
Received: by rv-out-0910.google.com with SMTP id k20so904822rvb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 06:54:29 -0800 (PST)
Message-ID: <1ba2fa240711270654r276657ch4e56e543a3c4a427@mail.gmail.com> (sfid-20071127_145443_306024_DCD37EF0)
Date: Tue, 27 Nov 2007 16:54:29 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH (2.6.24) 0/3] last minute iwlwifi fixes
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071126225416.467939000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071126225416.467939000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In general it is possible to change the mac address and there was a
patch for it if I remember correctly. It had some issues so I nacked
it, it slipped from my attention after that. I'll try to dig the
history.
Tomas

On Nov 27, 2007 12:54 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> So I took another look at iwlwifi and identified a bunch of user-visible
> problems with the drivers. Unfortunately, I was unable to fix one of them
> (MAC address setting ignored) so I added a workaround. I've repeatedly
> pointed out that iwlwifi needs fixing here but I guess for .24 we'll just
> have to live with not being able to change the MAC address.
>
> johannes
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
