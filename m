Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:11094 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbYEHVp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 17:45:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1366627waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 14:45:57 -0700 (PDT)
Message-ID: <1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com> (sfid-20080508_234457_676799_D547EC46)
Date: Fri, 9 May 2008 00:45:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
Cc: "Helmut Schaa" <hschaa@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1210246602.3547.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200805081030.57966.hschaa@suse.de>
	 <200805081334.07599.hschaa@suse.de>
	 <1210246602.3547.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 2:36 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-05-08 at 13:34 +0200, Helmut Schaa wrote:
>  > Some APs refuse association if the supported rates contained in the
>  > association request do not match its own supported rates. This patch
>  > introduces a new function which builds the intersection between the AP's
>  > supported rates and the client's supported rates to work around such
>  > problems. The same approach is already used in ipw2200 for example.
>  >
>  > Signed-off-by: Helmut Schaa <hschaa@suse.de>
>
>  Thanks. Looks ok to me.
>
>
>
Are we sure there is no  firmware with the fix for this AP?

Thanks
Tomas
