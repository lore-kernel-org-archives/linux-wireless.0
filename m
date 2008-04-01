Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:26941 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329AbYDAVGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 17:06:25 -0400
Received: by yw-out-2324.google.com with SMTP id 5so271652ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 14:06:24 -0700 (PDT)
Message-ID: <1ba2fa240804011406u5e5a0255te73be96d29882e1c@mail.gmail.com> (sfid-20080401_220649_697175_21C9AAB8)
Date: Wed, 2 Apr 2008 00:06:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/6] sta-info fixes, especially destroy()
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080331172258.541914000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080331172258.541914000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 31, 2008 at 8:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This series should fix the problems with sta_info_destroy() that
>  Tomas pointed out. Tomas, please give the patches a try, I don't
>  currently have a suitable IBSS test environment. Especially, it
>  would be worth trying out making an IBSS mode virtual interface
>  re-join an IBSS (to test the flush_delayed stuff.)
>

Thanks. I will test the IBSS with these patches, not sure it will
happen this week.

Tomas
