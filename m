Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:62519 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762397AbYEHWKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 18:10:43 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1378937waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 15:10:43 -0700 (PDT)
Message-ID: <1ba2fa240805081510x13ca192bsa219736707a8119b@mail.gmail.com> (sfid-20080509_000941_252489_066105F9)
Date: Fri, 9 May 2008 01:10:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
Cc: "Helmut Schaa" <hschaa@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1210283484.3547.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200805081030.57966.hschaa@suse.de>
	 <200805081334.07599.hschaa@suse.de>
	 <1210246602.3547.45.camel@johannes.berg>
	 <1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com>
	 <1210283484.3547.73.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2008 at 12:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > Are we sure there is no  firmware with the fix for this AP?
>
>  Even if there is, does it matter? Will everybody install it? It's not
>  like we're doing something that could cause problems since we announce
>  the subset that both we and the AP can support.

Fair enough.
Tomas
