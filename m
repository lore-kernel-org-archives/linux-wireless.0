Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:8698 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbXK0QAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:00:01 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1303183wah
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 08:00:00 -0800 (PST)
Message-ID: <1ba2fa240711270800p3312246as51b0a23f77e81f3@mail.gmail.com> (sfid-20071127_160009_664339_BBD90695)
Date: Tue, 27 Nov 2007 18:00:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH (2.6.24) 0/3] last minute iwlwifi fixes
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ian Schram" <ischram@telenet.be>
In-Reply-To: <1196175476.6058.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071126225416.467939000@sipsolutions.net>
	 <1ba2fa240711270654r276657ch4e56e543a3c4a427@mail.gmail.com>
	 <1196175476.6058.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 27, 2007 4:57 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2007-11-27 at 16:54 +0200, Tomas Winkler wrote:
> > In general it is possible to change the mac address and there was a
> > patch for it if I remember correctly. It had some issues so I nacked
> > it, it slipped from my attention after that. I'll try to dig the
> > history.
>
> Thanks. I didn't feel confident enough with the driver to make such a
> change since I have no idea where it should/would be uploaded to the
> hardware and whether maybe the ucode gets it from the eeprom too etc.
>
> If you can get a patch that makes this work I'm all for it since the
> mac80211 hack isn't too nice anyway.
>
I found it, there was a patch by Ian Schram <ischram@telenet.be>
'[PATCH] allow changing mac_addr by userspace'
It should work I nacked it just because I wanted to remove a filed he
was using, it never happened so I think we can apply it
for 24 and then I get back to rework it.
I'll resend it rebased to current everything.

> johannes
>
